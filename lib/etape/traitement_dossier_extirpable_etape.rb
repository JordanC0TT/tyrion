# frozen_string_literal: true

require "observer"

require "notification/traitement_notification"
require "etape/fichier"
require "dedoublonneur"

# Définit l'étape de traitement de dossier extirpable
class TraitementDossierExtirpableEtape
  include Observable

  attr_accessor :extracteur
  attr_reader :fichiers

  def initialize(extracteur, fichiers = {})
    @extracteur = extracteur
    @fichiers = fichiers
  end

  def parcours(dossiers)
    dossiers.each do |dossier|
      dedoublonneur = Dedoublonneur.new
      Dir.each_child(dossier) do |nom_fichier|
        begin
          changed
          fichier = "#{dossier}/#{nom_fichier}"
          notify_observers(Time.now, TraitementNotification.new(fichier))
          date_extraite = extracteur.extraction_du(nom_fichier)
          nom_attribue = dedoublonneur.dedoublonne_par_numerotation(date_extraite.strftime("photo_%Y_%m_%d-%H_%M_%S"))
          fichiers.store(fichier,
                        Fichier.new(nom_attribue, date_extraite, File.dirname(fichier), File.extname(fichier)))
        rescue ExtractionErreur
          notify_observers(Time.now, TraitementNotification.new(fichier))
        end
      end
    end
  end
end
