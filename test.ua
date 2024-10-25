# Experimental!

~ "lib"
  ~ BasicDoc Html
  ~ Body ExP P
  ~ Element Render
  ~ Head Title
  ~ Script Style

# ----------------

⍣(0 ◌Element~New 0 "ae"|1)
⍤"Expected `Element~New <invalid type>` to fail, but it passed"

⍣(0 ◌Element~WithProps "html" 0 "ae"|1)
⍤"Expected `Element~WithProps tag <invalid type>` to fail, but it passed"

# ----------------

⊙◌Element~Check P "Hello world"
⍤$"Element~Check failed with a valid element (_)".
⊙◌Element~Check "invalid tag"
⍤⊃$"Element~Check passed with an invalid element (_)"¬

# ----------------

$ Hello world!
$ Some sample text :)

⍤⤙≍ ⊃($"<p>_</p>"|Render P).
⍤⤙≍ ⊃($"<p class=\"hello\" id=\"world\">_</p>"|Render ExP map{"class" "id"}{"hello" "world"}).

⍣(0◌Render ExP map{"class" 1}{"hello" "world"}|0)
$ Expected `Render ExP map{"class" 1}{"hello" "world"} to fail due to `Render~Properties` failing, but both passed
⍤

# ----------------

⍣(1◌Render~Properties map{"class"}["link"]|0)
⍤$ Expected `Render~Properties map{"class"}["link"]` to pass, it failed"

⍣(0◌Render~Properties map{1}["link"]|1)
⍤$ Expected `Render~Properties map{1}["link"]` to fail, it passed"

⍣(1◌Render~Properties map{"class"}[1]|0)
⍤$ Expected `Render~Properties map{"class"}[1]` to pass, it failed"

# ----------------

BasicDoc [Title "Hello world!"] [P "Hi there!"]

⍤⤙≍ Html [
  Head [Title "Hello world!"]
  Body [P "Hi there!"]
]

⍤⤙≍ Html [Head 1 Body 2] BasicDoc 1 2
