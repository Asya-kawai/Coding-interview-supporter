(** 文字列に重複がないかどうかを判定するプログラム *)

let get_hash _ = 1

module Hash_table = struct
  module Data = struct
    type t = {
      pair: string * string;
      next: string * string;
    }
  end
  type t = Data.t array
  let get_bucket key hash_table = abs(get_hash(key)) mod Array.length(hash_table)
  let put (data: Data.t) hash_table =
    let b =
      let (key, value) = data.pair in
      get_bucket key hash_table
    in
    Array.set hash_table b data
end

(*

*)
