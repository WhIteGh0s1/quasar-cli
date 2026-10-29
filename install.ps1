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

# The beam: a bright head flies over a sky of twinkling stars and leaves
# its trail behind. Drawn in place, two lines, every 70 ms.
$W = 34
$seed = New-Object Random
$sky = foreach ($i in 0..($W - 1)) { if ($seed.NextDouble() -lt 0.45) { $seed.Next(0, 24) } else { -1 } }

function Show-Beam([long]$done, [long]$total, [double]$rate, [int]$frame) {
  $p = if ($total -gt 0) { [Math]::Min(1.0, $done / $total) } else { 0 }
  $pos = [int][Math]::Floor($p * ($W - 1))
  [Console]::SetCursorPosition(0, $script:top)
  Write-Host '  ' -NoNewline
  if ($pos -gt 2) { Write-Host ('━' * ($pos - 2)) -NoNewline -ForegroundColor DarkGray }
  if ($pos -gt 0) { Write-Host ('━' * [Math]::Min(2, $pos)) -NoNewline -ForegroundColor Gray }
  Write-Host @('◆', '◇')[[int]($frame / 3) % 2] -NoNewline -ForegroundColor White
  for ($i = $pos + 1; $i -lt $W; $i++) {
    $s = $sky[$i]
    if ($s -lt 0) { Write-Host ' ' -NoNewline; continue }
    $phase = ($frame + $s) % 24
    if ($phase -lt 2) { Write-Host '+' -NoNewline -ForegroundColor White }
    elseif ($phase -lt 4) { Write-Host '*' -NoNewline -ForegroundColor Gray }
    else { Write-Host '·' -NoNewline -ForegroundColor DarkGray }
  }
  Write-Host ('   {0,3}%' -f [int]($p * 100)) -ForegroundColor White
  $info = '  {0:0.0} из {1:0.0} МБ   {2:0.0} МБ/с' -f ($done / 1MB), ($total / 1MB), ($rate / 1MB)
  Write-Host $info.PadRight(52) -ForegroundColor DarkGray
}

Write-Host ''
Write-Host '  ◆ КВАЗАР' -ForegroundColor White
Write-Host '  VPN прямо в терминале' -ForegroundColor DarkGray
Write-Host ''
$fancy = $true
try { Write-Host ''; Write-Host ''; $script:top = [Console]::CursorTop - 2; [Console]::CursorVisible = $false } catch { $fancy = $false }

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
    $done = 0L; $frame = 0; $rate = 0.0; $mark = 0L; $markBytes = 0L; $drawn = 0L
    while ($true) {
      $read = $in.ReadAsync($buffer, 0, $buffer.Length)
      while (-not $read.Wait(70)) { $frame++; Show-Beam $done $total $rate $frame; $drawn = $clock.ElapsedMilliseconds }
      $n = $read.Result
      if ($n -le 0) { break }
      $out.Write($buffer, 0, $n)
      $done += $n
      $now = $clock.ElapsedMilliseconds
      if ($now - $mark -ge 400) { $rate = ($done - $markBytes) * 1000.0 / ($now - $mark); $mark = $now; $markBytes = $done }
      if ($now - $drawn -ge 70) { $frame++; Show-Beam $done $total $rate $frame; $drawn = $now }
    }
    $out.Close(); $in.Close(); $response.Close()
    foreach ($f in 1..6) { Show-Beam $total $total $rate ($frame + $f); Start-Sleep -Milliseconds 60 }
  } finally {
    [Console]::CursorVisible = $true
  }
  [Console]::SetCursorPosition(0, $script:top)
  Write-Host '  ✓ ' -NoNewline -ForegroundColor Green
  Write-Host ('Скачано  {0:0.0} МБ за {1:0} с' -f ($total / 1MB), $clock.Elapsed.TotalSeconds).PadRight(52)
  Write-Host (' ' * 52)
  [Console]::SetCursorPosition(0, $script:top + 1)
} else {
  Write-Host '  Скачиваю...' -ForegroundColor DarkGray
  Invoke-WebRequest $url -OutFile $exe -UseBasicParsing
}

& $exe install --quiet
Remove-Item $exe -ErrorAction SilentlyContinue
if (($env:Path -split ';') -notcontains $dir) { $env:Path = "$env:Path;$dir" }
Write-Host '  ✓ ' -NoNewline -ForegroundColor Green
Write-Host 'Установлено — теперь в любом окне просто пишите ' -NoNewline
Write-Host 'quasar' -ForegroundColor White
Write-Host ''
Start-Sleep -Milliseconds 900
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
