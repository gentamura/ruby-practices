# frozen_string_literal: true

class Bowling
  attr_accessor :scores, :shots, :frames

  def initialize(scores)
    @scores = scores[0].split(',')
    @shots = []
    @frames = []
  end

  def run
    build_shots
    build_frames

    total_point
  end

  private

  def build_shots
    @scores.each do |score|
      if score == 'X'
        @shots << 10
        @shots << 0
      else
        @shots << score.to_i
      end
    end
  end

  def build_frames
    @frames = @shots.each_slice(2).map do |first_frame, second_frame|
      first_frame == 10 || !second_frame ? [first_frame] : [first_frame, second_frame]
    end

    @frames = @frames[0..9].map.with_index do |frame, idx|
      last_frame = idx == 9

      if last_frame
        @frames.slice(idx..).reduce { |result, fr| result + fr }
      else
        frame
      end
    end
  end

  def total_point
    @frames.each_with_index.reduce(0) do |result, (frame, idx)|
      result + calcurate_point(frame, idx)
    end
  end

  def calcurate_point(frame, idx)
    return frame.sum if idx == 9 # 10 frame

    next_frame = next_frame(idx)
    next_next_frame = next_next_frame(idx)

    next_frame_point = 0
    next_next_frame_point = 0

    if strike?(frame)
      next_next_frame_point = next_next_frame[0] if idx.between?(0, 7) && strike?(next_frame)

      next_frame_point = next_frame[0..1].sum + next_next_frame_point
    elsif spare?(frame)
      next_frame_point = next_frame[0]
    end

    frame.sum + next_frame_point
  end

  def next_frame(idx)
    @frames[idx + 1]
  end

  def next_next_frame(idx)
    @frames[idx + 2]
  end

  def strike?(frame)
    frame[0] == 10
  end

  def spare?(frame)
    frame[0..1].sum == 10
  end
end
