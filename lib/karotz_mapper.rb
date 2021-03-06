module KarotzProxy
  class KarotzMapper
    attr_reader :db

    def initialize(db)
      @db = db
    end

    def save(karotz)
      if karotz.valid?
        db.save("karotzs", karotz.identifier, Yajl.dump(Hash[karotz.each_pair.to_a]))
        true
      else
        false
      end
    end

    def all
      db.all("karotzs").collect { |pair| create_karotz_from_hash(Yajl.load(pair.last)) }
    end

    def destroy_all
      db.destroy_all("karotzs")
    end

    private

    def create_karotz_from_hash(hash)
      Karotz.new.tap do |karotz|
        hash.each_pair do |key, value|
          karotz.send("#{key}=", value)
        end
      end
    end
  end
end
