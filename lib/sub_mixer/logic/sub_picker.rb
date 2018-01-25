module SubMixer
  class SubPicker
    def pick_subtitle(subs)
      valid_subs = subs.reject { |k, v| v.priority_flag == :drop }

      if valid_subs.size == 0
        # pick at least one if commanded to drop everything
        k = subs.keys[0]
        return k, subs[k]
      elsif valid_subs.size == 1
        k = valid_subs.keys[0]
        return k, valid_subs[k]
      end

      weight_sum = 0
      valid_subs.each do |k, v|
        if v.priority_flag == :pick_first
          return k, v
        end

        if v.priority < 0
          fail 'Priority cannot be negative'
        end

        weight_sum += v.priority
      end

      get_random_weighted_subtitle(valid_subs, weight_sum)
    end

    private

    def get_random_weighted_subtitle(subs, weight_sum)
      r = rand * weight_sum
      count_weight = 0

      subs.each do |k, v|
        count_weight += v.priority
        if count_weight >= r
          return k, v
        end
      end
    end
  end
end
