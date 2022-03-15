# frozen_string_literal: true

require "etape/application_etape"
require "etape/fichier"

RSpec.describe ApplicationEtape do
  describe "doit pouvoir appliquer" do
    before do
      @dossier_tmp = FileUtils.makedirs "#{FileHelpers::TMP}test01"
    end

    where(:case_name, :fichiers_crees, :fichiers, :attendu) do
      [
        ["aux fichiers",
          { "/2012/08" => ["IMG_20210803175810.jpg"] },
          { "/tmp/test01/2012/08/IMG_20210803175810.jpg" =>
            Fichier.new("photo_2021_08_03-17_58_10",
                          DateTime.new(2021, 8, 3, 17, 58, 10),
                          "/tmp/test01/2012/08",
                          ".jpg"
                        )
          },
          ["/tmp/test01/2012/08/JPG/photo_2021_08_03-17_58_10.jpg"]
        ]
      ]
    end
    with_them do
      it "pour en definir les fichiers à traités" do
        FileHelpers.build_fichiers(fichiers_crees, @dossier_tmp[0])

        ApplicationEtape.new.parcours(fichiers)

        attendu.each do |fichier|
          expect(File.exist?(fichier)).to be_truthy
        end
      end

      after do
        FileUtils.rm_rf(@dossier_tmp[0])
      end
    end
  end
end
