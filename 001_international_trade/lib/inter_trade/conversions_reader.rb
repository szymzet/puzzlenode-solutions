require 'rexml/document'

class ConversionsReader
  attr_reader :conversions

  def initialize(file)
    @conversions = []

    doc = REXML::Document.new(file)
    doc.elements.each('rates/rate') do |elem|
      @conversions <<
        [child_text(elem, 'from'),
         child_text(elem, 'to'),
         child_text(elem, 'conversion')]
    end
  end

  private

  def child_text(elem, name)
    elem.get_elements(name).first.text
  end
end
