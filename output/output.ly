\version "2.24.4" % Adjust version as needed
melody = { c' d' e' f' g' }
\score {
  \new Staff {
    \clef treble
    \new Voice = "melody" \melody
  }
}
