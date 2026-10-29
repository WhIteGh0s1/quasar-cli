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

# The mark and QUASAR in the app's dot style, Braille cells with a
# brightness digit for each (generated from cli/screen.go).
$mark = @(
  '         ⢸         |0000000002000000000',
  '         ⢸         |0000000002000000000',
  '         ⢸         |0000000003000000000',
  '      ⢀⣴⡾⠿⠿⣶⣄⣤⣤⣤⣤⣤⣄|0000001333332222111',
  '   ⣀⣠⣤⣾⡏   ⠈⣿⣿⣿⣿⡿⠟⠋|0002333300033322211',
  '⢠⣶⣿⣿⣿⣿⣿⣧⣶⡶⠶⣿⡟⠋⠉    |2233333333233210000',
  ' ⠉⠉⠉⠉⠉⠁⠈⠙⢻⠛⠉       |0222222133310000000',
  '         ⢸         |0000000003000000000',
  '         ⢸         |0000000002000000000',
  '         ⠸         |0000000001000000000'
)
$word = @(
  '⡎⠉⡆⢸ ⢸ ⣎⣉⡆⠰⣉⡉ ⣎⣉⡆⢸⣉⡱|33330303333330333333',
  '⠣⠕⠅⠘⠤⠜ ⠇ ⠇⠠⠤⠜ ⠇ ⠇⠸⠈⠢|33333303033330303333'
)

$e = [char]27
$levels = @("$e[38;2;0;0;0m", "$e[38;2;70;70;72m", "$e[38;2;150;150;154m", "$e[38;2;240;240;242m")
$width = 48
function Write-Art($rows) {
  foreach ($row in $rows) {
    $chars, $tones = $row -split '\|'
    $line = ' ' * [Math]::Floor(($width - $chars.Length) / 2) + '  '
    for ($i = 0; $i -lt $chars.Length; $i++) { $line += $levels[[int][string]$tones[$i]] + $chars[$i] }
    [Console]::Write("$line$e[0m`n")
  }
}
function Show-Bar([long]$done, [long]$total, [double]$rate, [string]$state) {
  $p = if ($total -gt 0) { [Math]::Min(1.0, $done / $total) } else { 0 }
  $full = [int][Math]::Floor($p * $width)
  $bar = "  $($levels[3])$('━' * $full)$e[38;2;40;40;44m$('━' * ($width - $full))$e[0m"
  $info = if ($total -gt 0) { '{0:0.0} / {1:0.0} МБ' -f ($done / 1MB), ($total / 1MB) } else { '' }
  $text = "$state"
  $pad = [Math]::Max(1, $width - $text.Length - $info.Length)
  [Console]::Write("$e[2A$e[2K$bar`n$e[2K  $($levels[2])$text$(' ' * $pad)$($levels[1])$info$e[0m`n")
}

$vt = $false
try { $vt = $Host.UI.SupportsVirtualTerminal -and -not [Console]::IsOutputRedirected } catch {}
if ($vt) {
  [Console]::Write("`n")
  Write-Art $mark
  [Console]::Write("`n")
  Write-Art $word
  [Console]::Write("`n`n`n`n")
  [Console]::CursorVisible = $false
  try {
    $clock = [Diagnostics.Stopwatch]::StartNew()
    $request = [Net.HttpWebRequest]::Create($url)
    $request.UserAgent = 'quasar-install'
    $response = $request.GetResponse()
    $total = $response.ContentLength
    $in = $response.GetResponseStream()
    $out = [IO.File]::Create($exe)
    $buffer = New-Object byte[] 131072
    $done = 0L; $drawn = -100L
    while ($true) {
      $n = $in.Read($buffer, 0, $buffer.Length)
      if ($n -le 0) { break }
      $out.Write($buffer, 0, $n)
      $done += $n
      if ($clock.ElapsedMilliseconds - $drawn -ge 50) { Show-Bar $done $total 0 'Загрузка'; $drawn = $clock.ElapsedMilliseconds }
    }
    $out.Close(); $in.Close(); $response.Close()
    Show-Bar $total $total 0 'Установка'
    & $exe install --quiet
    Show-Bar $total $total 0 'Готово'
  } finally {
    [Console]::CursorVisible = $true
  }
} else {
  Write-Host '  Загрузка Квазара…'
  Invoke-WebRequest $url -OutFile $exe -UseBasicParsing
  & $exe install --quiet
}

Remove-Item $exe -ErrorAction SilentlyContinue
if (($env:Path -split ';') -notcontains $dir) { $env:Path = "$env:Path;$dir" }
Start-Sleep -Milliseconds 600
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
