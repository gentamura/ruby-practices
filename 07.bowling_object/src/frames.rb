# frozen_string_literal: true

class Frames
  def initialize(frames)
    @frames = frames
  end

  def score
    @frames.each_with_index.reduce(0) do |result, (frame, idx)|
      result + calcurate_score(frame, idx)
    end
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
