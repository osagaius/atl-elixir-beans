use Amnesia
require Exquisite

defdatabase Beans.Db do
  # this defines a table with other attributes as ordered set, and defines an
  # additional indices to improvelookup operations
  deftable BeanClassification, [{ :id, autoincrement }, :name, :classification], type: :ordered_set, index: [:name, :classification] do
    # again not needed, but nice to have
    @type t :: %BeanClassification{id: non_neg_integer, name: String.t, classification: String.t}

    def add(bean_name, classification) do
      Amnesia.transaction fn ->
        %__MODULE__{name: bean_name, classification: classification} |> __MODULE__.write
      end

    end

    def find_by_name(bean_name) do
      Amnesia.transaction fn ->
        where(name == bean_name)
        |> Amnesia.Selection.values()
      end
    end

  end
end
