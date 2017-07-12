module IfHostTags
  include Radiant::Taggable
  
  class TagError < StandardError; end
  
  desc %{
    Renders the containing elements only if the current domain matches the regular expression given in the @matches@ attribute.
  }
  tag 'if_host' do |tag|
    raise TagError.new("`if_host' tag must contain a `matches' attribute.") unless tag.attr.has_key?('matches')
    regexp = build_regexp_for(tag, 'matches')
    tag.expand unless @request.host.match(regexp).nil?
  end
  
  desc %{
    Renders the containing elements unless the current domain matches the regular expression given in the @matches@ attribute.
  }
  tag 'unless_host' do |tag|
    raise TagError.new("`unless_host' tag must contain a `matches' attribute.") unless tag.attr.has_key?('matches')
    regexp = build_regexp_for(tag, 'matches')
    tag.expand if @request.host.match(regexp).nil?
  end
end