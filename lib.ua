# Experimental!
# NOTICE: uiua-html is experimental until `case` gets stabilized.
# Please excuse any inconveniencies this might cause.

# I've a feeling I'll use this more often than I think
IsMap ↚ ⍣(1⋅◌°map|0)

┌─╴Element
  CheckTag   ↚ ⍤⊃($"expected string for tag, got _"repr|↧⊃(=1type|=1⧻△))
  CheckAttrs ↚ (
    ⍤⊃($"expected map for attributes, got _"repr|IsMap).◴
    ¬has "style"
    ⍤ $ The 'style' attribute is prohibited from use.
      $ Please make a new file and use `Style` to import it.
  )

  MagicValue ↚ "\u{2024}"

  # This module holds the unsafe versions of
  # some functions and other unsafe parts of `Element`.
  ┌─╴Unsafe
    # `Element~WithAttrs`, but it does not check its arguments at runtime.
    # Only use if you're sure that your values match the expected types.
    # element ? tag content attributes
    WithAttrs ← $Element {MagicValue ⊓($Tag|$Attributes|$Content)⊙:}

    # `Element~New`, but it does not check its arguments at runtime.
    # Only use if you're sure that your values match the expected types.
    # element ? tag content
    New ← WithAttrs ⊙⊙(map{}[])

    # `Element~NoEndTag`, but it does not check its arguments at runtime.
    # Only use if you're sure that your values match the expected types.
    # element ? tag attributes
    NoEndTag ← $Element {MagicValue ⊓($Tag|$Attributes)}
  └─╴

  # Checks if the value is a valid element.
  # Returns whether it is, alongside the `reason` why not.
  # If it is an element, you're free to get rid of `reason`.
  # NOTE: It doesn't actually give an useful reason yet.
  # isElement reason ? value
  Check ← (
    ⍣(1 "hooray" ⋅⋅◌°Unsafe~WithAttrs
    | 1 "hooray" ⋅⋅◌°Unsafe~New
    | 1 "hooray" ⋅◌°Unsafe~NoEndTag
    | 0 "TODO: actually give the reason why"
    )
  )

  # Wraps the arguments into a new element with attributes attached.
  # Throws an error if `tag` isn't a string or `attributes` isn't a map.
  # element ? tag content attributes
  WithAttrs ← Unsafe~WithAttrs ⊓(CheckTag.|∘|CheckAttrs.)

  # Wraps the arguments into a new element.
  # Throws an error if `tag` isn't a string.
  # element ? tag content
  New ← Unsafe~New CheckTag.

  # Wraps its arguments into a new element with attributes and no end tag.
  # element ? tag attributes
  ExNoEndTag ← Unsafe~NoEndTag ⊓(CheckTag|CheckAttrs),,

  # Wraps the single argument into a new element with no end tag.
  # element ? tag
  NoEndTag ← ExNoEndTag ⊙(map{}[])
└─╴

# This module stores the raw element definitions of various elements,
# as well as their versions with attribute parameters (`Ex*`).
# Please note this module is **really unsafe and unstable**.
#
# For anything that should be exposed or abstracted,
# please [file an issue](https://github.com/thacuber2a03/uiua-html)
# in the code's repository, and in the meantime, refer to this module.
#
# For rare tags, or tags simply missing from this module,
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
      $$ Ex_ = Element~ExNoEndTag "_"
    ))

  Elements!(html|head|body|title)
  Elements!(ul|ol|li)
  Elements!(q|blockquote)
  Elements!(p|a|h1|h2|h3|h4|h5|h6)
  Elements!(b|i|strong|em)
  Elements!(script|style)
  NETElements!(br)
  NETElements!(link)
└─╴

# Generates a standard HTML document from the provided arguments.
# document ? head body
Document‼ ← $Document Raw~Html [$Head Raw~Head ^0 $Body Raw~Body ^1]

# Returns a new basic document from the provided arguments.
# A "basic document" is a page with only a title and some content.
# document ? title content
BasicDoc‼ ← Document‼[Raw~Title ^0] ^1

H₁   ← Raw~H₁   # h1 ? content
ExH₁ ← Raw~ExH₁ # h1 ? content attributes
H₂   ← Raw~H₂   # h2 ? content
ExH₂ ← Raw~ExH₂ # h2 ? content attributes
H₃   ← Raw~H₃   # h3 ? content
ExH₃ ← Raw~ExH₃ # h3 ? content attributes
H₄   ← Raw~H₄   # h4 ? content
ExH₄ ← Raw~ExH₄ # h4 ? content attributes
H₅   ← Raw~H₅   # h5 ? content
ExH₅ ← Raw~ExH₅ # h5 ? content attributes
H₆   ← Raw~H₆   # h6 ? content
ExH₆ ← Raw~ExH₆ # h6 ? content attributes

P   ← Raw~P   # p ? content
ExP ← Raw~ExP # p ? content attributes

# Includes a JavaScript file in classic mode.
# script ? filepath
ClassicScript ← Raw~ExScript "" map{"src"}{∘}

# Include a JavaScript module.
# module ? filepath
Script ← Raw~ExScript "" map{"type" "src"}{"module" ∘}

# Includes a CSS file.
# style ? filepath
Style ← Raw~ExLink map{"rel" "src"}["stylesheet" ∘]

# An ordered list.
# list ? values
List ← $List Raw~Ol ≡Raw~Li

# An unordered list.
# list ? values
UList ← $UList Raw~Ul ≡Raw~Li

# A hyperlink.
# hyperlink ? value link
Link ← Raw~ExA ⊙(map{"href"}{∘})

# A hyperlink with extra attributes.
# a ? value link attributes
ExLink ← Raw~ExA ⊙(insert "href")

Break   ← Raw~Br   # br ?
ExBreak ← Raw~ExBr # br ? attributes

# A quote with extra attributes.
# The underlying element depends on the argument:
# - multiline string or array of elements -- a <blockquote> element
# - anything else -- a <q> element
ExQuote ← (
  =1type.
  $Quote ⨬(
    Raw~ExBlockquote
  | ≠0/↥⌕@\n.
    ⨬(Raw~ExQ|Raw~ExBlockquote)
  )
)

# A quote. The underlying element depends on the argument:
# - multiline string or array of elements -- a <blockquote> element
# - anything else -- a <q> element
Quote ← ExQuote ⊙(map{}{})

Title   ← Raw~Title   # title ? value
ExTitle ← Raw~ExTitle # title ? value attributes

# The main rendering module. You're free to call this as a function,
# as its `Call` function is the main rendering function.
┌─╴Render
  # The map of characters that get replaced when you call `Escape`.
  EscapeMap ← comptime(map"&<>'\""{"&amp;" "&lt;" "&gt;" "&#39;" "&quot;"})

  # Escapes `value` so it renders safely.
  # escaped ? value
  Escape ← /(⊂∩°□)≡⍣(get:EscapeMap)

  # Renders a map into a single string of HTML element attributes.
  # Throws an error if any of the keys isn't a string.
  # string ? attributes
  Attributes ← (
    °map≡□
    ⟜⍚(⍤⊃($"all the keys in the map must be strings, found a _"repr|=1type))
    ≡(□$"_=\"_\"" ⊙(Escape$"_")°⊟)⍉⊟
    /$"_ _"
  )

  # Renders the `element` into HTML.
  # Unlike all safe `Element` calls, this function/module
  # accepts any value with no issues, since it gets escaped and
  # inserted into the resulting file. Useful for debugging.
  # rendered ? element
  Call ← |1 (
    =0⧻△.
    ⨬(type.
      ⨬(Escape repr
      | Escape
      | ⍣(≠0⧻.:⊙: °Element~Unsafe~WithAttrs
          ⨬($"<_>_</_>" ⟜(Call:)◌
          | $"<_ _>_</_>" :⊙⟜(Call:) caseAttributes
          )
        | ≠0⧻.: °Element~Unsafe~NoEndTag
          ⨬($"<_/>" ◌
          | $"<_ _/>" :caseAttributes
          )
        | /⊂ ≡(Call °□)
        | Escape repr)
      | Escape repr)
    | Escape repr)
  )

  # Render a document. This function differs from `Render`/`Render~Call` in that
  # it appends specific things that apply to full pages (<!DOCTYPE HTML> and the like).
  Doc ← (
    Call
    $$ <!DOCTYPE HTML>
    $$ _
  )
└─╴
