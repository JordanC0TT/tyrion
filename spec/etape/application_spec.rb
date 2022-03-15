# frozen_string_literal: true

require "etape/application"
require "etape/fichier"

RSpec.describe ApplicationEtape do
  describe "doit pouvoir parcourir" do
    
    before(:example) do
      @dossier_tmp = FileUtils.makedirs "#{FileHelpers::TMP}test01"
    end

    where(:case_name, :fichiers_crees, :fichiers, :attendu) do
      [
        ["le dossier '/2012/08'", { "/2012/08" => ["IMG_20210803175810.jpg"] }, 
        { "/tmp/test01/2012/08/IMG_20210803175810.jpg" => 
          Fichier.new("photo_2021_08_03-17_58_10", DateTime.new(2021, 8, 3, 17, 58, 10), "/tmp/test01/2012/08/", ".jpg") }, []
        ],
      ]
    end
    with_them do
      it "pour en definir les fichiers à traités" do
        FileHelpers.build_fichier(fichiers_crees, @dossier_tmp[0])

        ApplicationEtape.new.parcours(fichiers)
        
        # expect(traitement_etape.fichiers).to eql? attendu
      end

      after(:example) do
        FileUtils.rm_rf(@dossier_tmp[0])
      end
    end
  end
end
