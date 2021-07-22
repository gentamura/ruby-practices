# frozen_string_literal: true

require_relative './shot'
require_relative './frame'
require_relative './frames'

class Game
  def initialize(marks)
    @marks = marks.split(',')
  end

  def start
    frames = parse_marks(@marks)
    frames.score
  end

  private

  def parse_marks(marks)
    shots = []
    frames = []
    frame = []

    marks.each do |m|
      shots << Shot.new(m)
    end

    shots.each do |shot|
      frame << shot.score

      if frames.size < 10
        if frame.size >= 2 || shot.score == 10
          frames << frame.dup
          frame.clear
        end
      else # last frame
        frames.last << shot.score
      end
    end

    frame_objects = frames.map { |f| Frame.new(*f) }
    Frames.new(frame_objects)
  end
end
