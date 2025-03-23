import sublime
import sublime_plugin

class ForceUrlUnderlineListener(sublime_plugin.ViewEventListener):
    def on_load_async(self, view):
        self.highlight_urls(view)
        
    def on_modified_async(self, view):
        self.highlight_urls(view)
        
    def highlight_urls(self, view):
        # Only apply to Scrawl files
        syntax = view.settings().get('syntax')
        if not syntax or 'Scrawl' not in syntax:
            return
            
        # Find all URLs
        url_regions = view.find_all(r'(https?:\/\/|www\.)[a-zA-Z0-9][-a-zA-Z0-9]*(\.[a-zA-Z0-9][-a-zA-Z0-9]*)+(/[-a-zA-Z0-9_%&=\?\.~#]*)*')
        
        # Add underline style (using add_regions with underline flags)
        if url_regions:
            # The key parameter must be unique to this plugin
            view.add_regions(
                "scrawl_url_underlines", 
                url_regions, 
                "markup.underline.link.url",  # Scope for coloring 
                "",  # No icon
                sublime.DRAW_NO_FILL | sublime.DRAW_NO_OUTLINE | sublime.DRAW_SOLID_UNDERLINE,
                {"color": "#66D9EF"}  # Underline color
            )