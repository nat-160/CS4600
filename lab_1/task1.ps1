$lfreq = @{}; $bifreq = @{}; $trifreq = @{}
$lcount = 0; $bicount = 0; $tricount = 0
$data = (Get-Content "./ciphertext.txt").ToCharArray()

$alpha = 'a'..'z'

for ($i = 0; $i -lt $data.Length; $i++) {
  if ($data[$i] -in $alpha) {
    $lfreq[""+$data[$i]]++
    $lcount++
    if ($i -lt $data.Length - 1) {
      if ($data[$i + 1] -in $alpha) {
        $bifreq[$data[$i] + $data[$i + 1]]++
        $bicount++
        if ($i -lt $data.Length - 2) {
          if ($data[$i + 2] -in $alpha) {
            $trifreq[$data[$i] + $data[$i + 1] + $data[$i + 2]]++
            $tricount++
          }
        }
      }
    }
  }
}
$lfreq = [Collections.ArrayList]($lfreq.GetEnumerator() | Sort-Object -Descending -Property Value)
$bifreq = [Collections.ArrayList]($bifreq.GetEnumerator() | Sort-Object -Descending -Property Value)
$trifreq = [Collections.ArrayList]($trifreq.GetEnumerator() | Sort-Object -Descending -Property Value)

$content = Get-Content "./ciphertext.txt"

##trigrams##
#the, and, tha, ent, ing, ion, tio, for, nde, has, nce, edt, tis, oft, sth, men
##bigrams##
#th, he, in, en, nt, re, er, an, ti, es, on, at, se, nd, or, ar, al, te, co, de, to, ra, et, ed, it, sa, em, ro
##letters##
#e, t, a, o, i, n, s, r, h, d, l, u, c, m, f, y, w, g, p, b, v, k, x, q, j, z

$key = @{}

# Assume that most frequent trigram is THE
"Trigrams:"
"THE"
$key["T"] = $trifreq[0].Name[0]
$key["H"] = $trifreq[0].Name[1]
$key["E"] = $trifreq[0].Name[2]

"THA"
$i = 1
while($trifreq[$i].Name.SubString(0,2) -ne $trifreq[0].Name.SubString(0,2)){$i++}
$key["A"] = $trifreq[$i].Name[2]

"AND"
$i = 1
while($trifreq[$i].Name[0] -ne $key["A"]){$i++}
$key["N"] = $trifreq[$i].Name[1]
$key["D"] = $trifreq[$i].Name[2]

"Bigrams:"
"IN"
$i = 1
while($bifreq[$i].Name[1] -ne $key["N"]){$i++}
$key["I"] = $bifreq[$i].Name[0]
#Skip AN
$i++
while($bifreq[$i].Name[1] -ne $key["N"]){$i++}
"ON"
$i++
while($bifreq[$i].Name[1] -ne $key["N"]){$i++}
$key["O"] = $bifreq[$i].Name[0]
"Targeting Words:"
"THIS"
$s = $key["T"]+$key["H"]+$key["I"]+"[a-z] "
$key["S"] = "$content"[[regex]::Match($content, $s).Index+3]
"ANOTHER"
$s = $key["A"]+$key["N"]+$key["O"]+$key["T"]+$key["H"]+$key["E"]+"[a-z]"
$key["R"] = "$content"[[regex]::Match($content, $s).Index+6]
"DIRECTOR"
$s = $key["D"]+$key["I"]+$key["R"]+$key["E"]+"[a-z]"+$key["T"]+$key["O"]+$key["R"]
$key["C"] = "$content"[[regex]::Match($content, $s).Index+4]
"THOUSANDS"
$s = $key["T"]+$key["H"]+$key["O"]+"[a-z]"+$key["S"]+$key["A"]+$key["N"]+$key["D"]+$key["S"]
$key["U"] = "$content"[[regex]::Match($content, $s).Index+3]
"HISTORICAL"
$s = $key["H"]+$key["I"]+$key["S"]+$key["T"]+$key["O"]+$key["R"]+$key["I"]+$key["C"]+$key["A"]+"[a-z]"
$key["L"] = "$content"[[regex]::Match($content, $s).Index+9]
"GUESSES"
$s = "[a-z]"+$key["U"]+$key["E"]+$key["S"]+$key["S"]+$key["E"]+$key["S"]
$key["G"] = "$content"[[regex]::Match($content, $s).Index+0]
"CATEGORY"
$s = $key["C"]+$key["A"]+$key["T"]+$key["E"]+$key["G"]+$key["O"]+$key["R"]+"[a-z]"
$key["Y"] = "$content"[[regex]::Match($content, $s).Index+7]
"SUeeORT"
$s = $key["S"]+$key["U"]+"[a-z][a-z]"+$key["O"]+$key["R"]+$key["T"]
$key["P"] = "$content"[[regex]::Match($content, $s).Index+2]
"GLOgES"
$s = $key["G"]+$key["L"]+$key["O"]+"[a-z]"+$key["E"]+$key["S"]
$key["B"] = "$content"[[regex]::Match($content, $s).Index+3]
"ENSEcBLE"
$s = $key["E"]+$key["N"]+$key["S"]+$key["E"]+"[a-z]"+$key["B"]+$key["L"]+$key["E"]
$key["M"] = "$content"[[regex]::Match($content, $s).Index+4]
"AbTER"
$s = $key["A"]+"[a-z]"+$key["T"]+$key["E"]+$key["R"]
$key["F"] = "$content"[[regex]::Match($content, $s).Index+1]
"AlARDS"
$s = $key["A"]+"[a-z]"+$key["A"]+$key["R"]+$key["D"]+$key["S"]
$key["W"] = "$content"[[regex]::Match($content, $s).Index+1]
"LIsE"
$s = $key["L"]+$key["I"]+"[a-z]"+$key["E"]
$key["K"] = "$content"[[regex]::Match($content, $s).Index+2]
"HARfEY"
$s = $key["H"]+$key["A"]+$key["R"]+"[a-z]"+$key["E"]+$key["Y"]
$key["V"] = "$content"[[regex]::Match($content, $s).Index+3]
"oUST"
$s = "[a-z]"+$key["U"]+$key["S"]+$key["T"]
$key["J"] = "$content"[[regex]::Match($content, $s).Index+0]
"EkTRA"
$s = $key["E"]+"[a-z]"+$key["T"]+$key["R"]+$key["A"]
$key["X"] = "$content"[[regex]::Match($content, $s).Index+1]
"jUESTION"
$s = "[a-z]"+$key["U"]+$key["E"]+$key["S"]+$key["T"]+$key["I"]+$key["O"]+$key["N"]
$key["Q"] = "$content"[[regex]::Match($content, $s).Index+0]
"PRIZE"
$s = $key["P"]+$key["R"]+$key["I"]+"[a-z]"+$key["E"]
$key["Z"] = "$content"[[regex]::Match($content, $s).Index+3]
# replace
foreach ($k in $key.Keys) {
  $content = $content.Replace($key[$k], $k)
}
$key = $key.GetEnumerator() | Sort-Object -Property Name
$content
