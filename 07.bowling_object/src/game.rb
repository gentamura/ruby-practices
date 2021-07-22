# frozen_string_literal: true

require_relative './shot'
require_relative './frame'

class Game
  def initialize(marks)
    @marks = marks.split(',')
  end

  def start
    frames = parse_marks(@marks)
    total_score(frames)
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

    frames.map { |f| Frame.new(*f) }
  end

  def total_score(frames)
    frames.each_with_index.reduce(0) do |result, (frame, idx)|
      result + calcurate_score(frame, idx, frames)
    end
  end

  def calcurate_score(frame, idx, frames)
    return frame.score if idx == 9 # 10 frame

    next_frame = next_frame(frames, idx)
    next_next_frame = next_next_frame(frames, idx)

    next_frame_score = 0
    next_next_frame_score = 0

    if frame.strike?
      next_next_frame_score = next_next_frame.first_shot.score if idx.between?(0, 7) && next_frame.strike?

      next_frame_score = next_frame.first_shot.score + next_frame.second_shot.score + next_next_frame_score
    elsif frame.spare?
      next_frame_score = next_frame.first_shot.score
    end

    frame.score + next_frame_score
  end

  def next_frame(frames, idx)
    frames[idx + 1]
  end

  def next_next_frame(frames, idx)
    frames[idx + 2]
  end
end
