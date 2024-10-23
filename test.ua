~ "lib"
  ~ BasicDoc Html
  ~ Body H₁ H₂ H₃ P
  ~ Head Title

BasicDoc [
  Title "Hello world!"
] [
  H₁ "HEADER!!!!!"
  H₂ "Header!"
  H₃ "header..."
  P "Hi there!"
]

⍤⤙≍ Html [
  Head [
    Title "Hello world!"
  ]
  Body [
    H₁ "HEADER!!!!!"
    H₂ "Header!"
    H₃ "header..."
    P "Hi there!"
  ]
]
