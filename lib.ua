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

Subscripts ↚ comptime(map "123456" "₁₂₃₄₅₆")
Stylize    ↚ ⍜⊏(≡(get: Subscripts))⊸(⊚∈+@1⇡6)
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

# TODO: make this a macro

# Returns a new basic document out of its arguments.
# Does not check if they're elements or arrays of elements.
# document ? head body
BasicDoc ← Html [⊓($Head Head|$Body Body)]

# The main rendering module. You're free to call this as a function,
# as its `Call` function is the main rendering function.
┌─╴Render
  # Escapes `value` so it renders safely. Currently does nothing.
  # escaped ? value
  Escape ← (
    ∘
  )
  
  # Renders the `value` into HTML.
  # Unlike all safe `Element` calls, this function/module
  # accepts any value with no issues. Useful for debugging.
  # rendered ? value
  Call ← |1 (
    ≠0⧻△.
    ⨬(repr
    | type.
      ⨬(repr
      | Escape
      | ⍣(°Element~WithPropsUnsafe
          ⧻.:
          ⨬($"<_>_</_>" ⟜(Call:)◌
          | NULL)
        | /⊂≡(Call °□)
        | repr)
        ⍤"TODO: render properties" ≍NULL.
      | repr
      )
    )
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
