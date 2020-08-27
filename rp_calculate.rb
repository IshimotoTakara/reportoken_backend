require 'bigdecimal'
require 'bigdecimal/util'

# HPF(H):High Pass Filter
def HPF(hash)
    @rpx_table = Hash.new #hash(adress|RP1)
    @hash_values_array = hash.values     # 要素（配列）
    @median = @hash_values_array.size % 2 == 0 ? @hash_values_array[@hash_values_array.size/2 - 1, 2].inject(:+) / 2.0 
                                                         : @hash_values_array[@hash_values_array.size/2] # ダウンロード数の中央値
    @hash_high = hash.sort{ |a, b| b[1] <=> a[1] }.to_h.reject {|key, value| value <= @median} # 中央値以上のアイテム(降順にソート済み)（ハッシュ）
    @hash_low = hash.reject {|key, value| value > @median} # 中央値未満のアイテム（ハッシュ）
    @a = @hash_high.size # 中央値以上のアイテム数

    @hash_high_key = @hash_high.keys # 中央値以上のアイテムを格納しているハッシュのキー（配列）
    @hash_low_key = @hash_low.keys # 中央値未満のアイテムを格納しているハッシュのキー（配列）
    
    # 評価の傾斜をかける処理
    if @a <= 8
        for i in 0..@a-1
            @rpx_table.store(@hash_high_key[i],4 - 0.5 * i)
        end
    else
        for i in 0..@a-1
            @rpx_table.store(@hash_high_key[i],(4 - (4 / @a.to_f) * i).to_d.floor(1).to_f)
        end
    end

    # 中央値以上のアイテムはRP=0
    for i in 0..@hash_low.size-1
        @rpx_table.store(@hash_low_key[i],0)
    end

    return @rpx_table
end

# RP1の計算
def RP1(hash)
    @download = hash  # hash(アドレス|ダウンロード数)
    return HPF(@download)
end

# RP1の計算（一旦、適当なテーブルで、、、）
def RP2
    @rp2_table = Hash.new #hash(adress|RP2)
    return {"R8"=>4.0, "R4"=>3.6, "R12"=>3.3, "R16"=>3.0, "R15"=>2.7, "R3"=>2.4, "R11"=>2.1, "R7"=>1.8, "R18"=>1.5, "R2"=>1.2,"R6"=>0.9, "R10"=>0.6, "R14"=>0.3, "R1"=>0, "R5"=>0, "R9"=>0, "R13"=>0, "R17"=>0}
end

def RP
    # 中央値以上のアイテム数が２個の場合
    # RP1({'R1'=>10, 'R2'=>20, 'R3'=>30,'R4'=>40})
    # 中央値以上のアイテム数が4個の場合
    # RP1({'R1'=>10, 'R2'=>20, 'R3'=>30,'R4'=>40,'R5'=>10, 'R6'=>20, 'R7'=>30,'R8'=>40})
    # 中央値以上のアイテム数が８個の場合
    # RP1({'R1'=>10, 'R2'=>20, 'R3'=>30,'R4'=>40,'R5'=>10, 'R6'=>20, 'R7'=>30,'R8'=>40,
    # 'R9'=>10, 'R10'=>20, 'R11'=>30,'R12'=>40,'R13'=>10, 'R14'=>20, 'R15'=>30,'R16'=>40})
    
    # 中央値以上のアイテム数が13個の場合
    # ここのハッシュの入力は、IPFSから受け取る。上記のハッシュは参考までに、、、
    @rp1_table = RP1({'R1'=>10, 'R2'=>20, 'R3'=>30,'R4'=>40,'R5'=>10, 'R6'=>20, 'R7'=>30,'R8'=>40,'R9'=>10,
        'R10'=>20, 'R11'=>30,'R12'=>40,'R13'=>10, 'R14'=>20, 'R15'=>30,'R16'=>40,'R17'=>10, 'R18'=>20})
    
    # ここのハッシュの入力は、etheriumから受け取る。  
    @rp2_table = RP2()

    # RP1とRP2の加算をrp_table1に代入
    hash = [@rp1_table, @rp2_table]
    @rp_table1 = {}.merge(*hash) { |_key, v1, v2| v1 + v2 }

    # HPF(H)を用いて、傾斜をつける。
    p @rp_table2 = HPF(@rp_table1)
end

RP()