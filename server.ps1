$root = "D:\kid dayly"
$port = 8000

function Get-EnvValue($name) {
  $envPath = Join-Path $root ".env"

  if (Test-Path $envPath) {
    foreach ($line in Get-Content $envPath) {
      if ($line -match "^\s*$name\s*=\s*(.+?)\s*$") {
        return $matches[1].Trim('"').Trim("'")
      }
    }
  }

  return [Environment]::GetEnvironmentVariable($name)
}

function Send-Json($context, $statusCode, $data) {
  $json = $data | ConvertTo-Json -Depth 20
  $bytes = [Text.Encoding]::UTF8.GetBytes($json)

  $context.Response.StatusCode = $statusCode
  $context.Response.ContentType = "application/json; charset=utf-8"
  $context.Response.ContentLength64 = $bytes.Length
  $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  $context.Response.Close()
}

function Get-ResponseText($response) {
  if ($response.output_text) {
    return $response.output_text
  }

  foreach ($item in $response.output) {
    foreach ($content in $item.content) {
      if ($content.text) {
        return $content.text
      }
    }
  }

  return $null
}

function Handle-AiComment($context) {
  $apiKey = Get-EnvValue "OPENAI_API_KEY"
  $model = Get-EnvValue "OPENAI_MODEL"

  if (-not $model) {
    $model = "gpt-5.1-mini"
  }

  if (-not $apiKey -or $apiKey -eq "your_openai_api_key_here") {
    Send-Json $context 400 @{
      error = "OPENAI_API_KEY is missing. Create a .env file from .env.example and add your API key."
    }
    return
  }

  $reader = [IO.StreamReader]::new($context.Request.InputStream, [Text.Encoding]::UTF8)
  $bodyText = $reader.ReadToEnd()
  $report = $bodyText | ConvertFrom-Json

  $reportJson = $report | ConvertTo-Json -Depth 20
  $prompt = @"
Write a longer, more professional digital growth recommendation for Chinese parents.
Output Simplified Chinese only.
Write one paragraph, around 120 to 180 Chinese characters.
Analyze the digital growth score, learning trend, entertainment trend, reading time, top apps, and total screen time.
Use a concise, modern, parent-friendly tone inspired by Apple Screen Time, Fitbit, and Duolingo.
The advice must be specific, gentle, and actionable.
Do not provide medical advice.

Report:
$reportJson
"@

  $body = @{
    model = $model
    input = @(
      @{
        role = "developer"
        content = "You are a digital growth report assistant for Chinese parents."
      },
      @{
        role = "user"
        content = $prompt
      }
    )
  } | ConvertTo-Json -Depth 20

  try {
    $response = Invoke-RestMethod `
      -Uri "https://api.openai.com/v1/responses" `
      -Method Post `
      -Headers @{
        Authorization = "Bearer $apiKey"
        "Content-Type" = "application/json"
      } `
      -Body $body

    $comment = Get-ResponseText $response

    if (-not $comment) {
      throw "No text returned from OpenAI."
    }

    Send-Json $context 200 @{ comment = $comment }
  } catch {
    Send-Json $context 500 @{ error = $_.Exception.Message }
  }
}

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Kid Daily server running at http://localhost:$port/"

while ($listener.IsListening) {
  $context = $listener.GetContext()

  if ($context.Request.Url.AbsolutePath -eq "/api/ai-comment" -and $context.Request.HttpMethod -eq "POST") {
    Handle-AiComment $context
    continue
  }

  $path = [Uri]::UnescapeDataString($context.Request.Url.AbsolutePath.TrimStart("/"))

  if ([string]::IsNullOrWhiteSpace($path)) {
    $path = "index.html"
  }

  $rootPath = [IO.Path]::GetFullPath($root)
  $fullPath = [IO.Path]::GetFullPath([IO.Path]::Combine($rootPath, $path))

  if (-not $fullPath.StartsWith($rootPath)) {
    $context.Response.StatusCode = 403
    $context.Response.Close()
    continue
  }

  if (-not [IO.File]::Exists($fullPath)) {
    $context.Response.StatusCode = 404
    $context.Response.Close()
    continue
  }

  $extension = [IO.Path]::GetExtension($fullPath).ToLowerInvariant()
  $contentType = switch ($extension) {
    ".html" { "text/html; charset=utf-8" }
    ".css" { "text/css; charset=utf-8" }
    ".js" { "application/javascript; charset=utf-8" }
    default { "application/octet-stream" }
  }

  $bytes = [IO.File]::ReadAllBytes($fullPath)
  $context.Response.ContentType = $contentType
  $context.Response.ContentLength64 = $bytes.Length
  $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  $context.Response.Close()
}
