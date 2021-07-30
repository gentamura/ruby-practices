# frozen_string_literal: true

require_relative './shot'
require_relative './frame'
require_relative './frames'

class Game
  def initialize(marks)
    @marks = marks.split(',')
  end

  def start
    Frames.new(@marks).score
  end
end
