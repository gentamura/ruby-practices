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
    frames = []
    frame = []

    shots = marks.map { |m| Shot.new(m) }

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

    if frame.strike?
      score = frame.score + next_frame(idx).first_shot.score + next_frame(idx).second_shot.score

      if next_frame_a_strike_unitl_eight_frame?(idx)
        score += next_next_frame(idx).first_shot.score
      end

      score
    elsif frame.spare?
      frame.score + next_frame(idx).first_shot.score
    else
      frame.score
    end
  end

  def next_frame_a_strike_unitl_eight_frame?(idx)
    idx.between?(0, 7) && next_frame(idx).strike?
  end

  def next_frame(idx)
    @frames[idx + 1]
  end

  def next_next_frame(idx)
    @frames[idx + 2]
  end
end
