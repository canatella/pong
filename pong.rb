require 'gosu'

class Pong < Gosu::Window
  LARGEUR_FENETRE = 640
  LONGUEUR_FENETRE = 480
  LARGEUR_JOUEUR = 10
  LONGUEUR_JOUEUR = 40
  ESPACE_JOUEUR = 10
  VITESSE_BALLE = 3

  class Joueur
    def initialize(x)
      @longueur = Pong::LONGUEUR_JOUEUR
      @largeur = Pong::LARGEUR_JOUEUR
      @x = x
      @y = (Pong::LONGUEUR_FENETRE - @longueur) / 2
    end

    def largeur
      @largeur
    end

    def x
      @x
    end

    def y
      @y
    end

    def draw
      Gosu.draw_rect(self.x, self.y, @largeur, @longueur, Gosu::Color::WHITE)
    end

    def droite?
      @x > Pong::LARGEUR_FENETRE / 2
    end

    def monte
      @y = @y - 5
    end

    def descent
      @y = @y + 5
    end
  end

  class Balle
    attr_reader(:x, :y, :diametre, :sens)

    def initialize
      @diametre = 10
      @sens = 1
      @x = (Pong::LARGEUR_FENETRE - @diametre) / 2
      @y = (Pong::LONGUEUR_FENETRE - @diametre) / 2
    end

    def draw
      Gosu.draw_rect(@x, @y, @diametre, @diametre, Gosu::Color::WHITE)
    end

    def avance
      @x = @x + @sens * Pong::VITESSE_BALLE
    end

    def change_sens
      @sens = 0 - @sens
    end
  end

  def initialize
    super(Pong::LARGEUR_FENETRE, Pong::LONGUEUR_FENETRE)
    self.caption = "Pong!!!"
    @joueur1 = Joueur.new(Pong::ESPACE_JOUEUR)
    @joueur2 = Joueur.new(Pong::LARGEUR_FENETRE - Pong::ESPACE_JOUEUR - Pong::LARGEUR_JOUEUR)
    @balle = Balle.new
  end

  def touche_balle_x?(balle, joueur)
    if joueur.droite? && balle.x >= joueur.x - (balle.sens * balle.diametre)
      true
    elsif !joueur.droite? && balle.x <= joueur.x - (balle.sens * balle.diametre)
      true
    else
      false
    end
  end

  def touche_balle_y?(balle, joueur)
    if balle.y + balle.diametre >= joueur.y && joueur.y + Pong::LONGUEUR_JOUEUR >= balle.y
      true
    else
      false
    end
  end

  def touche_balle?(balle, joueur)
    if touche_balle_x?(balle, joueur) && touche_balle_y?(balle, joueur)
      true
    else
      false
    end
  end

  def update
    @balle.avance
    if touche_balle?(@balle, @joueur2) || touche_balle?(@balle, @joueur1)
      @balle.change_sens
    end
  end

  def draw
    @joueur1.draw
    @joueur2.draw
    @balle.draw
  end

  def button_up(bouton)
    if bouton == Gosu::KB_UP
      @joueur1.monte
    elsif bouton == Gosu::KB_DOWN
      @joueur1.descent
    elsif bouton == Gosu::KB_ESCAPE
      exit
    end
  end


end

Pong.new.show
