┌─╴Element
  # Wraps the arguments into a new element with properties attached.
  # element ? tag properties content
  WithProps ← $Element {⊓($Tag|$Properties|$Content)}
  
  # Wraps the arguments into a new element.
  # element ? tag content
  New ← WithProps ⊙(map{}[])
└─╴

Subscripts ← comptime(map "123456" "₁₂₃₄₅₆")
Stylize    ← ⍜⊏(≡(get: Subscripts))⊸(⊚∈+@1⇡6)
Elements! ←^ (
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
# document ? head body
BasicDoc ← Html {⊓($Head|$Body) Head ⊙Body}

BasicDoc {
  Title "Hello world!"
} {
  H₁ "HEADER!!!!!"
  H₂ "Header!"
  H₃ "header..."
  P "Hi there!"
}

# TODO: rendering

# demo syntax

# BasicDoc (
#   {Title!"Hello world!"
#    CSS $ ::root {
#        $   /* inline css!!! */
#        $ }
#    Link‼"text/javascript" "js/the/js.js"
#   }

#   {H₁!"HEADER!!!!!"
#    H₂!"Header!"
#    H₃!"header..."

#    P!"text"
#    P!$ some
#      $ more
#      $ text

#    UList!{
#       P!"ayo lists"
#       List!{
#         P!"lists within lists"
#         "this one's ordered tho"
#       }

#       # I don't like that this has
#       # to have two exclamation points
#       # for the macro idea to work
#       Anchor‼"so crazy" "https://uiua.org/"
#     }

#    P‼("paragraph with properties"
#       [{"class" "the"}
#        {"id" "paragraph"}]
#     )
#   }
# )
