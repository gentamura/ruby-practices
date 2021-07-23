# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require './src/main'

class LsTest < Minitest::Test
  TARGET_PATHNAME = Pathname('test/fixtures/sample-app')

  def test_exec_ls_with_window_width180
    expected = <<~TEXT.chomp
      Gemfile            Rakefile           bin                db                 node_modules       public             tmp
      Gemfile.lock       app                config             lib                package.json       storage            vendor
      README.md          babel.config.js    config.ru          log                postcss.config.js  test               yarn.lock
    TEXT

    assert_equal expected, Ls::Main.new(TARGET_PATHNAME, window_width: 180).exec
  end

  def test_exec_ls_with_window_width80
    expected = <<~TEXT.chomp
      Gemfile            bin                node_modules       tmp
      Gemfile.lock       config             package.json       vendor
      README.md          config.ru          postcss.config.js  yarn.lock
      Rakefile           db                 public
      app                lib                storage
      babel.config.js    log                test
    TEXT

    assert_equal expected, Ls::Main.new(TARGET_PATHNAME, window_width: 80).exec
  end

  def test_exec_ls_with_window_width50
    expected = <<~TEXT.chomp
      Gemfile            log
      Gemfile.lock       node_modules
      README.md          package.json
      Rakefile           postcss.config.js
      app                public
      babel.config.js    storage
      bin                test
      config             tmp
      config.ru          vendor
      db                 yarn.lock
      lib
    TEXT

    assert_equal expected, Ls::Main.new(TARGET_PATHNAME, window_width: 50).exec
  end

  def test_exec_ls_with_long
    expected = <<~TEXT.chomp
      total 672
      -rw-r--r--    1 gentamura  staff    2196  7 22 16:30 Gemfile
      -rw-r--r--    1 gentamura  staff    5489  7 22 16:30 Gemfile.lock
      -rw-r--r--    1 gentamura  staff     374  7 22 16:30 README.md
      -rw-r--r--    1 gentamura  staff     227  7 22 16:30 Rakefile
      drwxr-xr-x   11 gentamura  staff     352  7 22 16:30 app
      -rw-r--r--    1 gentamura  staff    1668  7 22 16:30 babel.config.js
      drwxr-xr-x   10 gentamura  staff     320  7 22 16:30 bin
      drwxr-xr-x   18 gentamura  staff     576  7 22 16:30 config
      -rw-r--r--    1 gentamura  staff     160  7 22 16:30 config.ru
      drwxr-xr-x    3 gentamura  staff      96  7 22 16:30 db
      drwxr-xr-x    4 gentamura  staff     128  7 22 16:30 lib
      drwxr-xr-x    4 gentamura  staff     128  7 22 16:30 log
      drwxr-xr-x  691 gentamura  staff   22112  7 22 16:31 node_modules
      -rw-r--r--    1 gentamura  staff     375  7 22 16:31 package.json
      -rw-r--r--    1 gentamura  staff     224  7 22 16:30 postcss.config.js
      drwxr-xr-x    9 gentamura  staff     288  7 22 16:30 public
      drwxr-xr-x    3 gentamura  staff      96  7 22 16:30 storage
      drwxr-xr-x   12 gentamura  staff     384  7 22 16:30 test
      drwxr-xr-x    8 gentamura  staff     256  7 22 16:30 tmp
      drwxr-xr-x    3 gentamura  staff      96  7 22 16:30 vendor
      -rw-r--r--    1 gentamura  staff  306678  7 22 16:31 yarn.lock
    TEXT

    assert_equal expected, Ls::Main.new(TARGET_PATHNAME, window_width: 180, long: true).exec
  end

  def test_exec_ls_with_dot_match
    expected = <<~TEXT.chomp
      .                  .gitattributes     Gemfile.lock       babel.config.js    db                 package.json       test
      ..                 .gitignore         README.md          bin                lib                postcss.config.js  tmp
      .browserslistrc    .ruby-version      Rakefile           config             log                public             vendor
      .git               Gemfile            app                config.ru          node_modules       storage            yarn.lock
    TEXT

    assert_equal expected, Ls::Main.new(TARGET_PATHNAME, window_width: 180, dot_match: true).exec
  end

  def test_exec_ls_with_reverse
    expected = <<~TEXT.chomp
      yarn.lock          test               postcss.config.js  log                config.ru          babel.config.js    README.md
      vendor             storage            package.json       lib                config             app                Gemfile.lock
      tmp                public             node_modules       db                 bin                Rakefile           Gemfile
    TEXT

    assert_equal expected, Ls::Main.new(TARGET_PATHNAME, window_width: 180, reverse: true).exec
  end

  def test_exec_ls_with_long_and_dot_match_and_reverse
    expected = <<~TEXT.chomp
      total 704
      -rw-r--r--    1 gentamura  staff  306678  7 22 16:31 yarn.lock
      drwxr-xr-x    3 gentamura  staff      96  7 22 16:30 vendor
      drwxr-xr-x    8 gentamura  staff     256  7 22 16:30 tmp
      drwxr-xr-x   12 gentamura  staff     384  7 22 16:30 test
      drwxr-xr-x    3 gentamura  staff      96  7 22 16:30 storage
      drwxr-xr-x    9 gentamura  staff     288  7 22 16:30 public
      -rw-r--r--    1 gentamura  staff     224  7 22 16:30 postcss.config.js
      -rw-r--r--    1 gentamura  staff     375  7 22 16:31 package.json
      drwxr-xr-x  691 gentamura  staff   22112  7 22 16:31 node_modules
      drwxr-xr-x    4 gentamura  staff     128  7 22 16:30 log
      drwxr-xr-x    4 gentamura  staff     128  7 22 16:30 lib
      drwxr-xr-x    3 gentamura  staff      96  7 22 16:30 db
      -rw-r--r--    1 gentamura  staff     160  7 22 16:30 config.ru
      drwxr-xr-x   18 gentamura  staff     576  7 22 16:30 config
      drwxr-xr-x   10 gentamura  staff     320  7 22 16:30 bin
      -rw-r--r--    1 gentamura  staff    1668  7 22 16:30 babel.config.js
      drwxr-xr-x   11 gentamura  staff     352  7 22 16:30 app
      -rw-r--r--    1 gentamura  staff     227  7 22 16:30 Rakefile
      -rw-r--r--    1 gentamura  staff     374  7 22 16:30 README.md
      -rw-r--r--    1 gentamura  staff    5489  7 22 16:30 Gemfile.lock
      -rw-r--r--    1 gentamura  staff    2196  7 22 16:30 Gemfile
      -rw-r--r--    1 gentamura  staff       6  7 22 16:30 .ruby-version
      -rw-r--r--    1 gentamura  staff     840  7 22 16:30 .gitignore
      -rw-r--r--    1 gentamura  staff     327  7 22 16:30 .gitattributes
      drwxr-xr-x    9 gentamura  staff     288  7 22 16:30 .git
      -rw-r--r--    1 gentamura  staff       9  7 22 16:30 .browserslistrc
      drwxr-xr-x    3 gentamura  staff      96  7 22 16:30 ..
      drwxr-xr-x   28 gentamura  staff     896  7 22 16:30 .
    TEXT

    assert_equal expected, Ls::Main.new(TARGET_PATHNAME, window_width: 180, long: true, dot_match: true, reverse: true).exec
  end
end
