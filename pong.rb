require 'gosu'

class Pong < Gosu::Window
  LARGEUR_FENETRE = 640
  LONGUEUR_FENETRE = 480
  LARGEUR_JOUEUR = 10
  LONGUEUR_JOUEUR = 40
  ESPACE_JOUEUR = 10
  VITESSE_JOUEUR = 5
  VITESSE_BALLE = 1


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
      @y = @y - Pong::VITESSE_JOUEUR
    end

    def descent
      @y = @y + Pong::VITESSE_JOUEUR
    end
  end

  class Balle
    attr_reader(:x, :y, :diametre, :sens, :angle)

    def initialize
      @diametre = 10
      @angle = angle_initial
      @x = (Pong::LARGEUR_FENETRE - @diametre) / 2
      @y = (Pong::LONGUEUR_FENETRE - @diametre) / 2
      @vitesse = Pong::VITESSE_BALLE
    end

    def angle_initial
      angle = Random.rand(Math::PI / 6) + Math::PI / 12
      cadran =  Random.rand(4)
      if cadran > 3
        angle = Math::PI - angle
      elsif cadran > 2
        angle = Math::PI + angle
      elsif cadran > 1
        angle *= -1
      end
      angle
    end

    def draw
      Gosu.draw_rect(@x, @y, @diametre, @diametre, Gosu::Color::WHITE)
    end

    def avance
      @x = @x + Math.cos(@angle) * @vitesse
      @y = @y + Math.sin(@angle) * @vitesse
    end

    def sens
      Math.cos(@angle) / Math.cos(@angle).abs
    end

    def change_sens_x
      @vitesse += 1
      @angle = Math::PI - @angle
    end

    def change_sens_y
      @angle *= -1
    end

    def touche_mur_y?
      return @y <= 0 || @y + @diametre >= Pong::LONGUEUR_FENETRE
    end
  end

  def initialize
    super(Pong::LARGEUR_FENETRE, Pong::LONGUEUR_FENETRE)
    self.caption = "Pong!!!"
    commencer
  end

  def commencer
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
    if touche_balle_x?(balle, joueur)
      if touche_balle_y?(balle, joueur)
        true
      else
        commencer
      end

    end
  end

  def update
    if button_down?(Gosu::KB_Q)
      @joueur1.monte
    elsif button_down?(Gosu::KB_A)
      @joueur1.descent
    elsif button_down?(Gosu::KB_UP)
      @joueur2.monte
    elsif button_down?(Gosu::KB_DOWN)
      @joueur2.descent
    end

    @balle.avance
    if touche_balle?(@balle, @joueur2) || touche_balle?(@balle, @joueur1)
      @balle.change_sens_x
    end
    if @balle.touche_mur_y?
      @balle.change_sens_y
    end
  end

  def draw
    @joueur1.draw
    @joueur2.draw
    @balle.draw
  end

  def button_up(bouton)
    if bouton == Gosu::KB_ESCAPE
      exit
    elsif bouton == Gosu::KB_R
      commencer
    end
  end


end

Pong.new.show
