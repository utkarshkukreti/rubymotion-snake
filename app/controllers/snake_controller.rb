class SnakeController < UIViewController
  def viewDidLoad
    @playingView = UIView.alloc.initWithFrame([[0, 0], [view.frame.size.width, view.frame.size.height - 20]])
    @playingView.backgroundColor = UIColor.whiteColor

    view.addSubview(@playingView)

    @startGame = UIButton.alloc.initWithFrame([[20, view.frame.size.height - 20], [view.frame.size.width - 20, 20]])
    @startGame.setTitle("Play", forState:UIControlStateNormal)
    @startGame.addTarget(self, action:'handleStartGameTap:', forControlEvents:UIControlEventTouchUpInside)

    view.addSubview(@startGame)
  end

  def handleStartGameTap(sender)
    if !@snake || (@snake && !@snake.active)
      @snake = Snake.new
      @snake.width = 320
      @snake.height = 460
      @snake.cellSize = 20
      @snake.maxLength = 15
      @snake.view = @playingView
      @snake.startGame

      @playingGame = true
    end
  end
end