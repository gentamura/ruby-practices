# frozen_string_literal: true

class Frames
  def initialize(marks)
    @frames = parse_marks(marks)
  end

  def score
    @frames.each_with_index.reduce(0) do |result, (frame, idx)|
      result + calcurate_score(frame, idx)
    end
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
        if frame.size >= 2 || shot.ten?
          frames << frame.dup
          frame.clear
        end
      else # 10 frame
        frames.last << shot.score
      end
    end

    frames.map { |f| Frame.new(*f) }
  end

  def calcurate_score(frame, idx)
    return frame.score if idx == 9 # 10 frame

    next_frame = next_frame(idx)
    next_next_frame = next_next_frame(idx)

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

  def next_frame(idx)
    @frames[idx + 1]
  end

  def next_next_frame(idx)
    @frames[idx + 2]
  end
end
