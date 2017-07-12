require File.dirname(__FILE__) + '/lib/cache_by_host.rb'
require_dependency 'application'

class IfHostTagsExtension < Radiant::Extension
  version "0.1"
  description "Adds r:if_host and r:unless_host tags to render different content for different domains"
  url "https://github.com/jomz/radiant-if_host_tags-extension"

  def activate
    Page.send :include, IfHostTags
    SiteController.send :include, CacheByHost
  end
end
