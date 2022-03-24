# frozen_string_literal: true

require "exif/mini_exiftool_manipulateur"
require "etape/exif_manipulateur"

require "mini_exiftool"

RSpec.describe MiniExiftoolManipulateur do
  describe "doit modifier la metadata" do
    before do
      @dossier_tmp = FileUtils.makedirs "#{FileHelpers::TMP}test01"
    end

    where(:case_name, :nom_fichier, :date_time_original, :type, :extension) do
      [
        ["Date time original au '2020:02:01 01:01:01'", "photo_2020_02_01-01-01-01", DateTime.new(2020, 2, 1, 1, 1, 1, '+1'), FileHelpers::IMAGE, ".jpeg"],
        ["Date time original au '2020:02:01 01:01:01'", "video_2020_02_01-01-01-01", DateTime.new(2020, 2, 1, 1, 1, 1), FileHelpers::VIDEO, ".mp4"]
      ]
    end
    with_them do
      it do
        fichier = ImageHelpers.creer_("#{FileHelpers::TMP}test01", nom_fichier, type, extension)
        
        MiniExiftoolManipulateur.new.set_datetimeoriginal(fichier, date_time_original)

        expect(ExifHelpers.get_datetime(fichier)).to eql date_time_original
      end

      after do
        FileUtils.rm_rf(@dossier_tmp[0])
      end
    end
  end

  describe "doit lever une exception lorsque" do
    before do
      @dossier_tmp = FileUtils.makedirs "#{FileHelpers::TMP}test03"
    end

    where(:case_name, :chemin_fichier, :erreur_message) do
      [
        ["quand le fichier n'est pas correct", "#{FileHelpers::TMP}test03/P00053.jpg", ""],
        ["quand le fichier n'existe pas", "", "File '' does not exist."]
      ]
    end
    with_them do
      it do
        File.new(chemin_fichier, "a") if chemin_fichier != ""
        
        mini_exiftool_manipulateur = MiniExiftoolManipulateur.new

        expect { mini_exiftool_manipulateur.set_datetimeoriginal(chemin_fichier, DateTime.new(2020, 2, 1, 1, 1, 1)) }
          .to raise_error(ExifManipulateur::ExifManipulateurErreur, erreur_message)
      end

      after do
        FileUtils.rm_rf(@dossier_tmp[0])
      end
    end
  end
end
