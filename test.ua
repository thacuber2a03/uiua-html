~ "lib"
  ~ BasicDoc Html
  ~ Body H₁ H₂ H₃ P
  ~ Element
  ~ Head Title

⍣(0 ◌Element~New 0 "ae"|1)
⍤"Expected `Element~New <invalid type>` to fail, but it passed"

⍣(0 ◌Element~WithProps "html" 0 "ae"|1)
⍤"Expected `Element~WithProps tag <invalid type>` to fail, but it passed"

⊙◌?Element~Check P "Hello world"
⍤"Element~Check failed with a valid tag"

BasicDoc [
  Title "Hello world!"
] [
  P "Hi there!"
]

⍤⤙≍ Html [
  Head [
    Title "Hello world!"
  ]
  Body [
    P "Hi there!"
  ]
]
