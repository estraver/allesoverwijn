require 'nokogiri'

class HtmlCounter < Nokogiri::XML::SAX::Document

  attr_accessor :tag_count, :text_count, :comment_count

  def initialize(filtered_tags = [])
    @filtered_tags = filtered_tags
  end

  def start_document
    @tag_count = Hash.new(0)
    @text_count = Hash.new(0)
    @comment_count = 0
    @current_tags = []
  end

  def start_element(name, attrs)
    # Keep track of the nesting
    @current_tags.push(name)

    if should_count?
      # Count the end element as well
      # count_tag(name.length * 2)
      count_tag(attrs.flatten.map(&:length).inject(0) {|sum, length| sum + length})
    end
  end

  def end_element(name)
    @current_tags.pop
  end

  def comment(string)
    count_comment(string.length) if should_count?
  end

  def characters(string)
    count_text(string.strip.length) if should_count?
  end

  def should_count?
    # Are we in a filtered tag ?
    (@current_tags & @filtered_tags).empty?
  end

  def count_text(count)
    @text_count[@current_tags.last] += count
  end

  def count_tag(count)
    @tag_count[@current_tags.last] += count
  end

  def count_comment(count)
    @comment_count[@current_tags.last] += count
  end
end
