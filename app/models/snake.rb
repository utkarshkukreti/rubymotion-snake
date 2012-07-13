class Snake
  attr_accessor :width, :height, :cellSize, :maxLength, :view, :active,
    :bits, :heading, :food, :score, :length

  def startGame
    @maxX = @width / @cellSize
    @maxY = @height / @cellSize

    @heading = :right
    @score = 0
    @length = 3
    @bits = [[@maxX / 2, @maxY / 2]]

    @squares = @maxX.times.map do |x|
      @maxY.times.map do |y|
        UIView.alloc.initWithFrame([[x * @cellSize, y * @cellSize], [@cellSize, @cellSize]]).tap do |square|
          view.addSubview(square)
        end
      end
    end

    placeFood

    @timer = NSTimer.scheduledTimerWithTimeInterval(0.15, target: self, selector: :loop, userInfo: nil, repeats: true)

    @panGestureRecognizer = UIPanGestureRecognizer.alloc.initWithTarget(self, action:'handlePanGesture:')
    @view.addGestureRecognizer(@panGestureRecognizer)

    @active = true
  end

  def loop
    draw
    advanceSnake
    checkCollision
  end

  def handlePanGesture(sender)
    return if sender.state != UIGestureRecognizerStateEnded

    translate = sender.translationInView(@playingView)

    if translate.x.abs > translate.y.abs
      if translate.x > 0
        @newHeading = :right
      else
        @newHeading = :left
      end
    else
      if translate.y > 0
        @newHeading = :down
      else
        @newHeading = :up
      end
    end
    if @heading == :down && @newHeading == :up ||
      @heading == :up && @newHeading == :down ||
      @heading == :left && @newHeading == :right ||
      @heading == :right && @newHeading == :left
      return
    end
    @heading = @newHeading
  end


  def advanceSnake
    head = @bits.last

    @bits << case @heading
    when :up
      [head.first, head.last - 1]
    when :right
      [head.first + 1, head.last]
    when :down
      [head.first, head.last + 1]
    when :left
      [head.first - 1, head.last]
    end

    @bits.shift if @bits.length == @length + 1
  end

  def checkCollision
    head = @bits.last

    if head == food
      @length += 1
      @score += 1
      placeFood
    elsif head.first < 0 || head.last < 0 || head.first > @maxX || head.last > @maxY || @bits.count(head) > 1
      resetGame
    end
  end

  def draw
    @maxX.times do |x|
      @maxY.times do |y|
        @squares[x][y].backgroundColor = if @bits.include?([x, y])
            UIColor.blackColor
          elsif @food == [x, y]
            UIColor.blueColor
          else
            UIColor.clearColor
          end
      end
    end
  end

  def placeFood
    x, y = rand(@maxX), rand(@maxY)
    if @bits.include?([x, y])
      placeFood
    else
      @food = [x, y]
    end
  end

  def resetGame
    @timer.invalidate
    @active = false

    @maxX.times.map do |x|
      @maxY.times.map do |y|
        @squares[x][y].removeFromSuperview
      end
    end

    alert = UIAlertView.alloc.initWithTitle("Game over", message:"You scored #{@score} point(s)!", delegate:nil, cancelButtonTitle:"Ok", otherButtonTitles:nil)
    alert.show
  end
end