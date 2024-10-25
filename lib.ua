# Experimental!
# NOTICE: uiua-html is experimental until `case` gets stabilized.
# Please excuse any inconveniencies this might cause.

# I've a feeling I'll use this more often than I think
IsMap ↚ ⍣(1⋅◌°map|0)

┌─╴Element
  CheckStack ↚ ⊓(
    ⍤⊃($"expected string for tag, got _"repr|↧⊃(=1type|=1⧻△)).
  | ⍤⊃($"expected map for attributes, got _"repr|IsMap).
  )

  # `Element~WithAttrs`, but it does not check its arguments at runtime.
  # Only use if you're sure that your values match the expected types.
  WithAttrsUnsafe ← $Element {⊓($Tag|$Attributes|$Content)}

  # `Element~New`, but it does not check its arguments at runtime.
  # Only use if you're sure that your values match the expected types.
  NewUnsafe ← WithAttrsUnsafe ⊙(map{}[])

  # `NoEndTag`, but it does not check its arguments at runtime.
  # Only use if you're sure that your values match the expected types.
  # element ? tag attributes
  NoEndTagUnsafe ← $Element {⊓($Tag|$Attributes)}

  # Checks if the value is a valid element.
  # Returns whether it is, alongside the `reason` why not.
  # If it is an element, you're free to get rid of `reason`.
  # NOTE: It doesn't actually give an useful reason yet.
  # isElement reason ? value
  Check ← (
    ⍣(1 "hooray" ⋅⋅◌°WithAttrsUnsafe
    | 1 "hooray" ⋅⋅◌°NewUnsafe
    | 1 "hooray" ⋅◌°NoEndTagUnsafe
    | 0 "TODO: actually give the reason why"
    )
  )

  # Wraps the arguments into a new element with attributes attached.
  # Throws an error if `tag` isn't a string or `attributes` isn't a map.
  # element ? tag attributes content
  WithAttrs ← WithAttrsUnsafe CheckStack

  # Wraps the arguments into a new element.
  # Throws an error if `tag` isn't a string.
  # element ? tag content
  New ← WithAttrs ⊙(map{}[])

  # Wraps its arguments into a new element with attributes and no end tag.
  NoEndTagEx ← NoEndTagUnsafe CheckStack

  # Wraps the single argument into a new element with no end tag.
  # element ? tag
  NoEndTag ← NoEndTagEx ⊙(map{}[])
└─╴

# This module stores the raw element definitions of various macros,
# as well as their versions with attribute parameters. (`Ex*`).
# For anything not yet exposed or abstracted, refer to this.
# For *incredibly* rare tags, or tags simply missing from this module,
# prefer the creation functions in the `Element` module.
┌─╴Raw
  # thanks to kai himself for this snippet
  Replace ↚ +⬚0⊏⊸⊃(⊗:⊙⋅∘)-
  Stylize ↚ Replace "123456" "₁₂₃₄₅₆"

  Elements! ↚^ (
    /$"_\n_"⍚(
      ,,⊸(⍜⊢¯Stylize)
      $$ _ ← Element "_"
      $$ Ex_ ← Element~WithAttrs "_"
    ))

  NETElements! ↚^ (
    /$"_\n_"⍚(
      ,,⊸(⍜⊢¯Stylize)
      $$ _ = Element~NoEndTag "_"
      $$ Ex_ = Element~NoEndTagEx "_"
    ))

  Elements!(html|head|body|title)
  Elements!(ul|ol|li)
  Elements!(q|blockquote)
  Elements!(p|a|h1|h2|h3|h4|h5|h6)
  Elements!(b|i|strong|em)
  Elements!(script|style)
  NETElements!(br)
└─╴

# Returns a new basic document out of its arguments.
# A "basic doc" is a doc with only a title and some content.
# document ? title content
BasicDoc‼ ← $BasicDoc Raw~Html [$Head Raw~Head [Raw~Title ^0] $Body Raw~Body ^1]

# A paragraph.
# paragraph ? value
P ← Raw~P

# A paragraph with extra attributes.
ExP ← Raw~ExP

# An inline script block.
# script ? code
Script ← Raw~Script

# A script file.
# script ? filepath
ScriptFile ← Raw~Script &fras

# An inline style block.
# style ? code
Style ← Raw~Style

# A style file.
# style ? filepath
StyleFile ← Raw~Style &fras

# An ordered list.
# list ? values
List! ← $List Raw~Ol ≡Raw~Li ^0

# An unordered list.
# list ? values
UList! ← $UList Raw~Ul ≡Raw~Li ^0

# A hyperlink.
# hyperlink ? value link
Link‼ ← Raw~ExA map{"href"}{^1} ^0

# A hyperlink with extra attributes.
# hyperlink ? value link attributes
ExLink‼! ← Raw~ExA insert "href" ^1 ^2 ^0

# A line break.
# element ?
Break ← Raw~Br

# A line break with extra attributes.
# element ? attributes
ExBreak ← Raw~ExBr

# A quote. The underlying element depends on the argument:
# - multiline string or array of elements -- a <blockquote> element
# - anything else -- a <q> element
Quote! ← (
  =1type. ^0 # for intent
  $Quote ⨬(
    Raw~Blockquote
  | ≠0/↥⌕@\n.
    ⨬(Raw~Q|Raw~Blockquote)
  )
)

H₁ ← Raw~H₁
H₂ ← Raw~H₂
H₃ ← Raw~H₃
H₄ ← Raw~H₄
H₅ ← Raw~H₅
H₆ ← Raw~H₆

# The main rendering module. You're free to call this as a function,
# as its `Call` function is the main rendering function.
┌─╴Render
  # The map of characters that get replaced when you call `Escape`.
  EscapeMap ← comptime(map"&<>'\""{"&amp;" "&lt;" "&gt;" "&#39;" "&quot;"})

  # Escapes `value` so it renders safely. Currently does nothing.
  # escaped ? value
  Escape ← /(⊂∩°□)≡(⍣(get:EscapeMap))

  # Renders a map into a single string of HTML element attributes.
  # Throws an error if any of the keys isn't a string.
  # string ? attributes
  Attributes ← (
    °map≡□
    ⟜⍚(⍤⊃($"all the keys in Attributes must be strings, found a _"repr|=1type))
    ≡(□$"_=\"_\"" ⊙(Escape$"_")°⊟)⍉⊟
    /$"_ _"
  )

  # Renders the `value` into HTML.
  # Unlike all safe `Element` calls, this function/module
  # accepts any value with no issues. Useful for debugging.
  # rendered ? value
  Call ← |1 (
    =0⧻△.
    ⨬(type.
      ⨬(repr
      | Escape
      | ⍣(≠0⧻.: °Element~WithAttrsUnsafe
          ⨬($"<_>_</_>" ⟜(Call:)◌
          | $"<_ _>_</_>" :⊙⟜(Call:) caseAttributes)
        | ≠0⧻.: °Element~NoEndTagUnsafe
          ⨬($"<_ />" ◌
          | $"<_ _/>" :caseAttributes)
        | /⊂≡(Call °□)
        | repr)
      | repr)
    | repr)
  )

  # Render a Doc. This function differs from `Render`/`Render~Call` in that
  # it appends specific things that apply to full pages (<!DOCTYPE HTML> and the like).
  Doc ← (
    Call
    $$ <!DOCTYPE HTML>
    $$ _
  )
└─╴

# demo syntax (not real) (not final either)

# BasicDoc (
#   [Title!"Hello world!"
#    CSS $ ::root {
#        $   /* inline css!!! */
#        $ }
#    Link‼"text/javascript" "js/the/js.js"
#   ]

#   [H₁!"HEADER!!!!!"
#    H₂!"Header!"
#    H₃!"header..."

#    P!"text"
#    P!$ some
#      $ more
#      $ text

#    UList![
#       P!"ayo lists"
#       List![
#         P!"lists within lists"
#         "this one's ordered tho"
#       ]

#       # I don't like that this has
#       # to have two exclamation points
#       # for the macro idea to work
#       Anchor‼"so crazy" "https://uiua.org/"
#     ]

#    P‼("paragraph with attributes"
#       [{"class" "the"}
#        {"id" "paragraph"}]
#     )
#   ]
# )
