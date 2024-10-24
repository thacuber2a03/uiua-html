# Experimental!
# NOTICE: uiua-html is experimental until `case` gets stabilized.
# Please excuse any inconveniencies this might cause.

# I've a feeling I'll use this more often than I think
IsMap ↚ ⍣(1⋅◌°map|0)

┌─╴Element
  CheckStack ↚ ⊓(
    ⍤⊃($"expected string for tag, got _"repr|↧⊃(=1type|=1⧻△)).
  | ⍤⊃($"expected map for properties, got _"repr|IsMap).
  )
  
  # `Element~WithProps`, but it does not check its arguments at runtime.
  # Only use if you're sure that your values match the expected types.
  WithPropsUnsafe ← $Element {⊓($Tag|$Properties|$Content)}
  
  # `Element~New`, but it does not check its arguments at runtime.
  # Only use if you're sure that your values match the expected types.
  NewUnsafe ← WithPropsUnsafe ⊙(map{}[])
  
  # Checks if the value is a valid element.
  # Returns whether it is, alongside the `reason` why not.
  # If it is an element, you're free to get rid of `reason`.
  # NOTE: It doesn't actually give an useful reason yet.
  # isElement reason ? value
  Check ← ⍣(
    1 "hooray" ⋅⋅◌°WithPropsUnsafe
  | 1 "hooray" ⋅⋅◌°NewUnsafe
  | 0 "TODO: actually give the reason why"
  )
  
  # Wraps the arguments into a new element with properties attached.
  # Throws an error if `tag` isn't a string or `properties` isn't a map.
  # element ? tag properties content
  WithProps ← WithPropsUnsafe CheckStack
  
  # Wraps the arguments into a new element.
  # Throws an error if `tag` isn't a string.
  # element ? tag content
  New ← WithProps ⊙(map{}[])
└─╴

# thanks to kai himself for this snippet
Replace   ↚ +⬚0⊏⊸⊃(⊗:⊙⋅∘)-
Stylize   ↚ Replace "123456" "₁₂₃₄₅₆"
Elements! ↚^ (
  ≡⍚(
    ,,⊸(⍜⊢¯Stylize)
    $$ _ ← Element "_"
    $$ Ex_ ← Element~WithProps "_"
  )
  /$"_\n_"
)

Elements!(html|head|body|title)
Elements!(p|a|ul|ol|il)
Elements!(h1|h2|h3|h4|h5|h6)
Elements!(script|style)

# TODO: make this a macro

# Returns a new basic document out of its arguments.
# Does not check if they're elements or arrays of elements.
# document ? head body
BasicDoc ← Html [⊓($Head Head|$Body Body)]

# The main rendering module. You're free to call this as a function,
# as its `Call` function is the main rendering function.
┌─╴Render
  # The map of characters that get replaced when you call `Escape`.
  EscapeMap ← comptime(map"&<>'\""{"&amp;" "&lt;" "&gt;" "&#39;" "&quot;"})
  
  # Escapes `value` so it renders safely. Currently does nothing.
  # escaped ? value
  Escape ← /(⊂∩°□)≡(⍣(get:EscapeMap))
  
  # Renders a map into a single string of HTML element properties.
  # Throws an error if any of the keys isn't a string.
  # string ? properties
  Properties ← (
    °map≡□
    ⟜⍚(⍤⊃($"all the keys in Properties must be strings, found a _"repr|=1type))
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
      | ⍣(≠0⧻.: °Element~WithPropsUnsafe
          ⨬($"<_>_</_>" ⟜(Call:)◌
          | $"<_ _>_</_>" :⊙⟜(Call:) caseProperties)
        | /⊂≡(Call °□)
        | repr)
      | repr)
    | repr)
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

#    P‼("paragraph with properties"
#       [{"class" "the"}
#        {"id" "paragraph"}]
#     )
#   ]
# )
