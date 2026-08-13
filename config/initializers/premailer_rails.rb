# Keep responsive rules in the document head after Premailer inlines all
# element-level declarations. Text parts are maintained explicitly alongside
# each Devise HTML template instead of being generated from markup.
Premailer::Rails.config.merge!(
  generate_text_part: false,
  preserve_styles: true,
  remove_scripts: true,
  strategies: [ :filesystem, :propshaft, :network ]
)
