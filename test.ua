# Experimental!

~ "lib"
  ~ BasicDoc‼
  ~ Break ExBreak
  ~ Element Raw Render
  ~ ExLink‼! Link‼
  ~ ExP H₁ P
  ~ List! Quote! UList!
  ~ Script Style

# ---------------
# type assertions
# ---------------

⍣(0 ◌Element~New 0 "ae"|1)
⍤"Expected `Element~New <invalid type>` to fail, but it passed"

⍣(0 ◌Element~WithAttrs "html" 0 "ae"|1)
⍤"Expected `Element~WithAttrs tag <invalid type>` to fail, but it passed"

# -------------
# Element~Check
# -------------

⊙◌Element~Check P "Hello world"
⍤$"Element~Check failed with a valid element (_)".
⊙◌Element~Check "invalid tag"
⍤⊃$"Element~Check passed with an invalid element (_)"¬

# -----------------
# element rendering
# -----------------

$ Hello world!
$ Some sample text :)

⍤⤙≍ ⊃($"<p>_</p>"|Render P).
⍤⤙≍ ⊃($"<p class=\"hello\" id=\"world\">_</p>"|Render ExP map{"class" "id"}{"hello" "world"}).

⍣(0◌Render ExP map{"class" 1}{"hello" "world"}|1)
$ Expected `Render ExP map{"class" 1}{"hello" "world"} to fail due to `Render~Attributes` failing, but both passed
⍤

# --------------------
# no end tag rendering
# --------------------

⍤⤙≍ ⊃$"<br />"Render Break
⍤⤙≍ ⊃$"<br class=\"hello\" id=\"world\"/>"Render ExBreak map{"class" "id"}["hello" "world"]

# --------------------
# attributes rendering
# --------------------

⍣(1◌Render~Attributes map{"class"}["link"]|0)
⍤$ Expected `Render~Attributes map{"class"}["link"]` to pass, it failed"

⍣(0◌Render~Attributes map{1}["link"]|1)
⍤$ Expected `Render~Attributes map{1}["link"]` to fail, it passed"

⍣(1◌Render~Attributes map{"class"}[1]|0)
⍤$ Expected `Render~Attributes map{"class"}[1]` to pass, it failed"

# ------------
# abstractions
# ------------

BasicDoc‼"Hello world!" [P "Hi there!"]
⍤⤙≍ Raw~Html [
  Raw~Head [Raw~Title "Hello world!"]
  Raw~Body [P "Hi there!"]
]

BasicDoc‼1 2
⍤⤙≍ Raw~Html [
  Raw~Head [Raw~Title 1]
  Raw~Body 2
]

List!["a" "b" "c"]
⍤⤙≍ Raw~Ol[Raw~Li "a" Raw~Li "b" Raw~Li "c"]

UList!["a" "b" "c"]
⍤⤙≍ Raw~Ul[Raw~Li "a" Raw~Li "b" Raw~Li "c"]

⍤⤙≍ ⊃(Raw~Q|Quote!) "Abandon nominativity. Embrace relativity."

$ IwbnfouevcmsiehwvudbqvGovernment.
$ -- Winston Churchill
⍤⤙≍ ⊃(Raw~Blockquote|Quote!)

LinkText ← "this is a link"
Link     ← "https://uiua.org"

⍤⤙≍ (Raw~ExA map{"href"}{Link} LinkText) Link‼LinkText Link
⍤⤙≍ (Raw~ExA map{"id" "href"}{"a" Link} LinkText) ExLink‼!LinkText Link (map{"id"}{"a"})

⍤⤙≍ (Raw~H₁ "the") H₁ "the"
