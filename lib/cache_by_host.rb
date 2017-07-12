module CacheByHost
  def self.included(klass)
    klass.class_eval do
      def show_page
        response.headers.delete('Cache-Control')
        url = params[:url].to_s
        cache_key = cache_key_for_url(url) # Use cache_key, not raw URL
        if live? and (@cache.response_cached?(cache_key))
          @cache.update_response(cache_key, response)
          @performed_render = true
        else
          show_uncached_page(url)
        end
      end

      private
        def cache_key_for_url(url)
          "#{request.host}/#{url}"
        end

        def show_uncached_page(url)
          @page = find_page(url)
          unless @page.nil?
            @page.process(request, response)
            cache_key = cache_key_for_url(url) # Use cache key, not raw URL
            @cache.cache_response(cache_key, response) if live? and @page.cache?
            @performed_render = true
          else
            render :template => 'site/not_found', :status => 404
          end
        rescue Page::MissingRootPageError
          redirect_to welcome_url
        end
    end
  end
  
  
end