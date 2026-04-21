{
  scientifica,
  fontforge,
}: (scientifica.overrideAttrs (oldAttrs: {
  # Pull in FontForge to manipulate the font file
  nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [fontforge];

  postInstall =
    (oldAttrs.postInstall or "")
    +
    # py
    ''
      cat << 'EOF' > fix-mono.py
      import fontforge
      import psMat
      import sys

      target_font_path = sys.argv[1]
      output_font_path = sys.argv[2]
      regular_font_path = sys.argv[3]

      reg_font = fontforge.open(regular_font_path)
      ref_width = reg_font['A'].width - 50
      reg_font.close()

      font = fontforge.open(target_font_path)

      # Calculate the internal vector value of "1 pixel"
      char_pixel_width = 5
      pixel_unit = int(ref_width / char_pixel_width)

      for g in font.glyphs():
          # Enforce strict monospace width
          g.width = ref_width

          # Shift the visual drawing of EVERY character to the right by 1 "pixel"
          g.transform(psMat.translate(pixel_unit, 0))

      font.os2_family_class = 2057
      font.os2_panose = (2, 9, 0, 0, 0, 0, 0, 0, 0, 0)

      # Rename the font
      font.familyname = "Scientifica Mono"

      if '-' in font.fontname:
          style = font.fontname.split('-')[-1]
          font.fontname = f"ScientificaMono-{style}"
          font.fullname = f"Scientifica Mono {style}"
      else:
          font.fontname = "ScientificaMono"
          font.fullname = "Scientifica Mono"

      # Save the font
      font.generate(output_font_path)
      EOF
    ''
    +
    # bash
    ''
      # Remove italic
      # rm -f $out/share/fonts/truetype/*Italic*.ttf

      tmp_dir=$(mktemp -d)

      REGULAR_FONT=$(find $out/share/fonts/truetype -type f -iname "scientifica.ttf" | head -n 1)

      # Run the script on the installed TTF files
      for f in $out/share/fonts/truetype/*.ttf; do
        basename=$(basename "$f")
        new_basename=$(echo "$basename" | sed 's/\([sS]cientifica\)/\1-mono/')

        fontforge -lang=py -script fix-mono.py "$f" "$tmp_dir/$new_basename" "$REGULAR_FONT"
      done

      # Clean out the original fonts and replace them with our renamed ones
      rm $out/share/fonts/truetype/*.ttf
      mv $tmp_dir/*.ttf $out/share/fonts/truetype/
    '';
}))
