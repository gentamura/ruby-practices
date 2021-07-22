# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/game'

class GameTest < Minitest::Test
  def test_all_strike
    game = Game.new('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal 300, game.start
  end

  def test_case164
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal 164, game.start
  end

  def test_case107
    game = Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal 107, game.start
  end

  def test_case134
    game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    assert_equal 134, game.start
  end
end
