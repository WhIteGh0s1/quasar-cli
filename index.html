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

$e = [char]27
function Fg($c) { "$e[38;2;$($c[0]);$($c[1]);$($c[2])m" }
function Bg($c) { "$e[48;2;$($c[0]);$($c[1]);$($c[2])m" }
$white = 236, 236, 238; $muted = 148, 150, 158; $faint = 96, 98, 106
$panel = 34, 34, 38; $track = 62, 62, 70; $green = 118, 224, 152; $shadow = 78, 80, 88
$reset = "$e[0m"
$width = 64

# The same five-pixel «квазар» the app draws, two pixels per row in half blocks.
$font = @{
  'к' = '#..#', '#.#.', '##..', '#.#.', '#..#'
  'в' = '###.', '#..#', '###.', '#..#', '###.'
  'а' = '.##.', '...#', '.###', '#..#', '.###'
  'з' = '###.', '...#', '.##.', '...#', '###.'
  'р' = '###.', '#..#', '###.', '#...', '#...'
}
function Get-Logo {
  $px = @{}
  $x = 0
  foreach ($ch in 'квазар'.ToCharArray()) {
    $rows = $font[[string]$ch]
    for ($r = 0; $r -lt 5; $r++) { for ($c = 0; $c -lt 4; $c++) { if ($rows[$r][$c] -eq '#') { $px["$($x + $c),$r"] = 'w' } } }
    $x += 5
  }
  foreach ($k in @($px.Keys)) {
    $p = $k -split ','; $s = "$([int]$p[0] + 1),$([int]$p[1] + 1)"
    if (-not $px.ContainsKey($s)) { $px[$s] = 'g' }
  }
  $lines = @()
  for ($row = 0; $row -lt 3; $row++) {
    $line = ''
    for ($col = 0; $col -lt 31; $col++) {
      $t = $px["$col,$(2 * $row)"]; $b = $px["$col,$(2 * $row + 1)"]
      $tc = if ($t -eq 'w') { $white } elseif ($t) { $shadow } else { $null }
      $bc = if ($b -eq 'w') { $white } elseif ($b) { $shadow } else { $null }
      if (-not $tc -and -not $bc) { $line += "$reset " }
      elseif (-not $tc) { $line += "$reset$(Fg $bc)▄" }
      elseif (-not $bc) { $line += "$reset$(Fg $tc)▀" }
      else { $line += "$(Fg $tc)$(Bg $bc)▀" }
    }
    $lines += $line + $reset
  }
  $lines
}

function Get-Row([string]$text, [int]$visible, $accent) {
  "  $(Bg $accent) $(Bg $panel)  $text$(Bg $panel)$(' ' * [Math]::Max(0, $width - 3 - $visible))$reset"
}

function Show-Install([long]$done, [long]$total, [double]$rate, [string]$state, $accent, [bool]$first) {
  $p = if ($total -gt 0) { [Math]::Min(1.0, $done / $total) } else { 0 }
  $bar = 40
  $full = [int][Math]::Floor($p * $bar)
  $percent = '{0}%' -f [int]($p * 100)
  $title = "$(Fg $white)$e[1m$state$e[22m"
  $line1 = Get-Row ($title + (' ' * ($width - 7 - $state.Length - $percent.Length)) + "$(Fg $muted)$percent") ($width - 7) $accent
  $line2 = Get-Row ("$(Fg $white)$('█' * $full)$(Fg $track)$('█' * ($bar - $full))") $bar $accent
  $blank = Get-Row '' 0 $accent
  $info = '{0:0.0} / {1:0.0} МБ   {2:0.0} МБ/с' -f ($done / 1MB), ($total / 1MB), ($rate / 1MB)
  $hint = "$(' ' * (2 + $width - $info.Length))$(Fg $faint)$info$reset"
  if (-not $first) { [Console]::Write("$e[6A") }
  foreach ($l in $blank, $line1, $blank, $line2, $blank, $hint) { [Console]::Write("$e[2K$l`n") }
}

$vt = $false
try { $vt = $Host.UI.SupportsVirtualTerminal -and -not [Console]::IsOutputRedirected } catch {}
$clock = [Diagnostics.Stopwatch]::StartNew()
if ($vt) {
  [Console]::Write("`n")
  foreach ($l in Get-Logo) { [Console]::Write("  $(' ' * [Math]::Floor(($width - 31) / 2))$l`n") }
  [Console]::Write("`n")
  [Console]::CursorVisible = $false
  try {
    $request = [Net.HttpWebRequest]::Create($url)
    $request.UserAgent = 'quasar-install'
    $response = $request.GetResponse()
    $total = $response.ContentLength
    $in = $response.GetResponseStream()
    $out = [IO.File]::Create($exe)
    $buffer = New-Object byte[] 131072
    $done = 0L; $rate = 0.0; $mark = 0L; $markBytes = 0L; $drawn = -100L
    Show-Install 0 $total 0 'Скачиваю Квазар' $white $true
    while ($true) {
      $n = $in.Read($buffer, 0, $buffer.Length)
      if ($n -le 0) { break }
      $out.Write($buffer, 0, $n)
      $done += $n
      $now = $clock.ElapsedMilliseconds
      if ($now - $mark -ge 400) { $rate = ($done - $markBytes) * 1000.0 / ($now - $mark); $mark = $now; $markBytes = $done }
      if ($now - $drawn -ge 60) { Show-Install $done $total $rate 'Скачиваю Квазар' $white $false; $drawn = $now }
    }
    $out.Close(); $in.Close(); $response.Close()
    Show-Install $total $total $rate 'Устанавливаю' $white $false
    & $exe install --quiet
    Show-Install $total $total $rate 'Готово' $green $false
  } finally {
    [Console]::CursorVisible = $true
  }
} else {
  Write-Host '  Скачиваю Квазар…'
  Invoke-WebRequest $url -OutFile $exe -UseBasicParsing
  & $exe install --quiet
}

Remove-Item $exe -ErrorAction SilentlyContinue
if (($env:Path -split ';') -notcontains $dir) { $env:Path = "$env:Path;$dir" }
Start-Sleep -Milliseconds 700
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
