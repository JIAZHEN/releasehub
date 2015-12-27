module ApplicationHelper
  MARKDOWN_OPTIONS = {
    fenced_code_blocks: true,
    autolink: true,
    tables: true,
    disable_indented_code_blocks: true,
    lax_spacing: true,
    underline: true,
    highlight: true,
    quote: true,
    no_intra_emphasis: true
  }
  MARKDOWN = Redcarpet::Markdown.new(Redcarpet::Render::HTML, MARKDOWN_OPTIONS)

  def markdown
    MARKDOWN
  end

end
