<#<!--
#>
# Квазар в терминале. Установка: irm quasar.ghostlink.online | iex
# Этот файл — одновременно скрипт PowerShell и страница для браузера.
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
$url = 'https://github.com/WhIteGh0s1/quasar-cli/releases/latest/download/quasar.exe'
$exe = Join-Path $env:TEMP 'quasar-setup.exe'
$dir = Join-Path $env:USERPROFILE '.quasar\bin'

# One rounded panel redrawn in place: the name, a progress bar with a smooth
# leading edge over a dark track, and the numbers under it.
$inner = 44
$bar = 34
$edges = @('', '▏', '▎', '▍', '▌', '▋', '▊', '▉')

function Write-Row([object[]]$parts) {
  $used = 0
  Write-Host '  │  ' -NoNewline -ForegroundColor DarkGray
  for ($i = 0; $i -lt $parts.Count; $i += 2) {
    Write-Host $parts[$i] -NoNewline -ForegroundColor $parts[$i + 1]
    $used += $parts[$i].Length
  }
  Write-Host (' ' * [Math]::Max(0, $inner - 2 - $used)) -NoNewline
  Write-Host '│' -ForegroundColor DarkGray
}

function Show-Panel([long]$done, [long]$total, [double]$rate, [string]$note) {
  $p = if ($total -gt 0) { [Math]::Min(1.0, $done / $total) } else { 0 }
  $eighths = [int][Math]::Floor($p * $bar * 8)
  $full = [Math]::Floor($eighths / 8)
  $edge = $edges[$eighths % 8]
  $rest = $bar - $full - $edge.Length
  [Console]::SetCursorPosition(0, $script:top)
  Write-Host ('  ╭' + ('─' * $inner) + '╮') -ForegroundColor DarkGray
  Write-Row @()
  Write-Row @('◆ ', 'White', 'Квазар', 'White')
  Write-Row @()
  Write-Row @(('█' * $full) + $edge, 'White', ('█' * $rest), 'DarkGray', ('{0,6}' -f ('{0}%' -f [int]($p * 100))), 'Gray')
  if ($note) {
    Write-Row @($note, 'Gray')
  } else {
    Write-Row @(('{0:0.0} / {1:0.0} МБ' -f ($done / 1MB), ($total / 1MB)), 'Gray', ('   {0:0.0} МБ/с' -f ($rate / 1MB)), 'DarkGray')
  }
  Write-Row @()
  Write-Host ('  ╰' + ('─' * $inner) + '╯') -ForegroundColor DarkGray
}

Write-Host ''
$fancy = $true
try {
  1..8 | ForEach-Object { Write-Host '' }
  $script:top = [Console]::CursorTop - 8
  [Console]::CursorVisible = $false
} catch { $fancy = $false }

$clock = [Diagnostics.Stopwatch]::StartNew()
if ($fancy) {
  try {
    $request = [Net.HttpWebRequest]::Create($url)
    $request.UserAgent = 'quasar-install'
    $response = $request.GetResponse()
    $total = $response.ContentLength
    $in = $response.GetResponseStream()
    $out = [IO.File]::Create($exe)
    $buffer = New-Object byte[] 131072
    $done = 0L; $rate = 0.0; $mark = 0L; $markBytes = 0L; $drawn = -100L
    while ($true) {
      $n = $in.Read($buffer, 0, $buffer.Length)
      if ($n -le 0) { break }
      $out.Write($buffer, 0, $n)
      $done += $n
      $now = $clock.ElapsedMilliseconds
      if ($now - $mark -ge 400) { $rate = ($done - $markBytes) * 1000.0 / ($now - $mark); $mark = $now; $markBytes = $done }
      if ($now - $drawn -ge 60) { Show-Panel $done $total $rate ''; $drawn = $now }
    }
    $out.Close(); $in.Close(); $response.Close()
    Show-Panel $total $total $rate 'Устанавливаю…'
    & $exe install --quiet
    Show-Panel $total $total $rate ('✓ Готово за {0:0} с' -f $clock.Elapsed.TotalSeconds)
  } finally {
    [Console]::CursorVisible = $true
  }
} else {
  Write-Host '  Скачиваю Квазар…' -ForegroundColor Gray
  Invoke-WebRequest $url -OutFile $exe -UseBasicParsing
  & $exe install --quiet
}

Remove-Item $exe -ErrorAction SilentlyContinue
if (($env:Path -split ';') -notcontains $dir) { $env:Path = "$env:Path;$dir" }
Write-Host ''
Write-Host '  Дальше в любом окне просто пишите ' -NoNewline -ForegroundColor DarkGray
Write-Host 'quasar' -ForegroundColor White
Start-Sleep -Milliseconds 1200
& (Join-Path $dir 'quasar.exe')
<#-->
<!doctype html>
<html lang="ru">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Квазар в терминале</title>
<style>
  :root { color-scheme: dark; }
  * { box-sizing: border-box; }
  .page { position: fixed; inset: 0; overflow: auto; background: #000; color: #f2f2f2;
    font: 16px/1.5 -apple-system, "Segoe UI", Inter, Roboto, sans-serif;
    display: flex; align-items: center; justify-content: center; padding: 24px 16px; }
  main { width: 100%; max-width: 620px; }
  .mark { font-size: 13px; letter-spacing: .32em; color: #8a8a8a; margin-bottom: 28px; }
  h1 { font-size: clamp(32px, 7vw, 52px); line-height: 1.05; margin: 0 0 14px; font-weight: 600; letter-spacing: -.02em; }
  p { color: #9a9a9a; margin: 0 0 32px; max-width: 30em; }
  .cmd { display: flex; align-items: center; gap: 12px; background: #111; border-radius: 22px;
    padding: 16px 16px 16px 22px; font: 15px/1.4 "Cascadia Code", Consolas, ui-monospace, monospace; }
  .cmd code { flex: 1; overflow-x: auto; white-space: nowrap; }
  .cmd code b { color: #7dff9a; font-weight: 400; }
  button { border: 0; border-radius: 999px; background: #f2f2f2; color: #000; font: 600 14px/1 inherit;
    font-family: -apple-system, "Segoe UI", sans-serif; padding: 11px 18px; cursor: pointer; flex: none; }
  button:active { transform: scale(.97); }
  ol { color: #9a9a9a; padding-left: 20px; margin: 32px 0 0; }
  ol li { margin: 6px 0; }
  ol b { color: #f2f2f2; font-weight: 500; }
  .foot { margin-top: 40px; font-size: 13px; color: #5c5c5c; }
  .foot a { color: #8a8a8a; }
</style>
</head>
<body>
<div class="page">
<main>
  <div class="mark">◆ КВАЗАР</div>
  <h1>VPN прямо в терминале</h1>
  <p>Одна команда — и готово. Разрешение Windows спрашивается один раз, дальше Квазар держит подключение сам, даже после перезагрузки.</p>
  <div class="cmd"><code id="cmd"><b>irm</b> quasar.ghostlink.online | <b>iex</b></code><button id="copy">Копировать</button></div>
  <ol>
    <li>Откройте <b>PowerShell</b> и вставьте команду.</li>
    <li>Напишите <b>quasar</b> и вставьте ссылку на свою подписку.</li>
    <li>Стрелки — сервер, <b>Enter</b> — подключиться, <b>Q</b> — выйти. VPN останется включённым.</li>
  </ol>
  <div class="foot">Windows 10 и 11 · <a href="https://github.com/WhIteGh0s1/quasar-cli/releases/latest">quasar.exe напрямую</a></div>
</main>
</div>
<script>
  document.getElementById('copy').onclick = function () {
    var b = this;
    navigator.clipboard.writeText(document.getElementById('cmd').innerText).then(function () {
      b.textContent = 'Скопировано'; setTimeout(function () { b.textContent = 'Копировать'; }, 1600);
    });
  };
</script>
<template>#>
