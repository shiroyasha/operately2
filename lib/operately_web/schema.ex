defmodule OperatelyWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom

  object :update do
    field :id, non_null(:id)
    field :content, non_null(:string)
    field :updateable_id, non_null(:id)
    field :inserted_at, non_null(:naive_datetime)

    field :author, :person do
      resolve fn update, _, _ ->
        person = Operately.People.get_person!(update.author_id)

        {:ok, person}
      end
    end

    field :comments, list_of(:comment) do
      resolve fn update, _, _ ->
        comments = Operately.Updates.list_comments(update.id)

        {:ok, comments}
      end
    end
  end

  object :comment do
    field :id, non_null(:id)
    field :content, non_null(:string)
    field :inserted_at, non_null(:naive_datetime)

    field :author, :person do
      resolve fn comment, _, _ ->
        person = Operately.People.get_person!(comment.author_id)

        {:ok, person}
      end
    end
  end

  object :tenet do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :description, :string
  end

  object :objective do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :description, :string

    field :owner, :person do
      resolve fn objective, _, _ ->
        person = Operately.Okrs.get_owner!(objective)

        {:ok, person}
      end
    end
  end

  object :kpi do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :description, :string
  end

  object :person do
    field :id, non_null(:id)
    field :full_name, non_null(:string)
    field :title, :string
    field :avatar_url, :string
  end

  object :project do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :description, :string
    field :updated_at, non_null(:date)

    field :owner, :person do
      resolve fn objective, _, _ ->
        person = Operately.Projects.get_owner!(objective)

        {:ok, person}
      end
    end
  end

  object :group_contact do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :type, non_null(:string)
    field :value, non_null(:string)
  end

  object :group do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :mission, :string

    field :members, list_of(non_null(:person)) do
      resolve fn group, _, _ ->
        people = Operately.Groups.list_members(group)

        {:ok, people}
      end
    end

    field :points_of_contact, list_of(non_null(:group_contact)) do
      resolve fn group, _, _ ->
        contacts = Operately.Groups.list_contacts(group)

        {:ok, contacts}
      end
    end
  end

  object :key_result do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :status, non_null(:string)
    field :updated_at, non_null(:date)
  end

  input_object :create_kpi_input do
    field :name, non_null(:string)
    field :description, :string
    field :unit, non_null(:string)
    field :target, non_null(:integer)
    field :target_direction, non_null(:string)
    field :warning_threshold, non_null(:integer)
    field :warning_direction, non_null(:string)
    field :danger_threshold, non_null(:integer)
    field :danger_direction, non_null(:string)
  end

  input_object :create_objective_input do
    field :name, non_null(:string)
    field :description, :string
    field :timeframe, non_null(:string)
    field :owner_id, non_null(:id)
  end

  input_object :create_update_input do
    field :content, non_null(:string)
    field :updatable_id, non_null(:id)
    field :updatable_type, non_null(:string)
  end

  input_object :create_comment_input do
    field :content, non_null(:string)
    field :update_id, non_null(:id)
  end

  input_object :contact_input do
    field :name, non_null(:string)
    field :value, non_null(:string)
    field :type, non_null(:string)
  end

  query do
    field :me, :person do
      resolve fn _, _, %{context: context} ->
        {:ok, context.current_account.person}
      end
    end

    field :kpis, list_of(:kpi) do
      resolve fn _, _, _ ->
        kpis = Operately.Kpis.list_kpis()

        {:ok, kpis}
      end
    end

    field :kpi, :kpi do
      arg :id, non_null(:id)

      resolve fn args, _ ->
        kpi = Operately.Kpis.get_kpi!(args.id)

        {:ok, kpi}
      end
    end

    field :objectives, list_of(:objective) do
      resolve fn _, _, _ ->
        objectives = Operately.Okrs.list_objectives()

        {:ok, objectives}
      end
    end

    field :objective, :objective do
      arg :id, non_null(:id)

      resolve fn args, _ ->
        objective = Operately.Okrs.get_objective!(args.id)

        {:ok, objective}
      end
    end

    field :groups, list_of(:group) do
      resolve fn _, _, _ ->
        groups = Operately.Groups.list_groups()

        {:ok, groups}
      end
    end

    field :group, :group do
      arg :id, non_null(:id)

      resolve fn args, _ ->
        group = Operately.Groups.get_group!(args.id)

        {:ok, group}
      end
    end

    field :tenets, list_of(:tenet) do
      resolve fn _, _, _ ->
        tenets = Operately.Tenets.list_tenets()

        {:ok, tenets}
      end
    end

    field :tenet, :tenet do
      arg :id, non_null(:id)

      resolve fn args, _ ->
        tenet = Operately.Tenets.get_tenet!(args.id)

        {:ok, tenet}
      end
    end

    field :projects, list_of(:project) do
      resolve fn _, _, _ ->
        projects = Operately.Projects.list_projects()

        {:ok, projects}
      end
    end

    field :project, :project do
      arg :id, non_null(:id)

      resolve fn args, _ ->
        project = Operately.Projects.get_project!(args.id)

        {:ok, project}
      end
    end

    field :search_people, list_of(:person) do
      arg :query, non_null(:string)

      resolve fn args, _ ->
        people = Operately.People.search_people(args.query)

        {:ok, people}
      end
    end

    field :potential_group_members, list_of(:person) do
      arg :group_id, non_null(:id)
      arg :query, :string
      arg :exclude_ids, list_of(:id)
      arg :limit, :integer

      resolve fn args, _ ->
        people = Operately.Groups.list_potential_members(
          args.group_id,
          args.query,
          args.exclude_ids,
          args.limit
        )

        {:ok, people}
      end
    end

    field :key_results, list_of(:key_result) do
      arg :objective_id, non_null(:id)

      resolve fn args, _ ->
        objective_id = args.objective_id
        key_results = Operately.Okrs.list_key_results!(objective_id)

        {:ok, key_results}
      end
    end

    field :aligned_projects, list_of(:project) do
      arg :objective_id, non_null(:id)

      resolve fn args, _ ->
        objective_id = args.objective_id
        projects = Operately.Okrs.list_aligned_projects!(objective_id)

        {:ok, projects}
      end
    end

    field :updates, list_of(:update) do
      arg :updatable_id, non_null(:id)
      arg :updatable_type, non_null(:string)

      resolve fn args, _ ->
        updatable_id = args.updatable_id
        updatable_type = args.updatable_type
        updates = Operately.Updates.list_updates(updatable_id, updatable_type)

        {:ok, updates}
      end
    end
  end

  mutation do
    field :create_group, :group do
      arg :name, non_null(:string)

      resolve fn args, _ ->
        Operately.Groups.create_group(%{name: args.name})
      end
    end

    field :create_project, :project do
      arg :name, non_null(:string)
      arg :description, :string

      resolve fn args, _ ->
        Operately.Projects.create_project(%{name: args.name, description: args[:description] || "-"})
      end
    end

    field :create_tenet, :tenet do
      arg :name, non_null(:string)
      arg :description, :string

      resolve fn args, _ ->
        Operately.Tenets.create_tenet(%{name: args.name, description: args[:description] || "-"})
      end
    end

    field :create_kpi, :kpi do
      arg :input, non_null(:create_kpi_input)

      resolve fn args, _ ->
        Operately.Kpis.create_kpi(args.input)
      end
    end

    field :create_objective, :objective do
      arg :input, non_null(:create_objective_input)

      resolve fn args, _ ->
        owner_id = args.input.owner_id

        ownership = %{
          target_type: :objective,
          person_id: owner_id
        }

        params =
          args.input
          |> Map.delete(:owner_id)
          |> Map.put(:ownership, ownership)

        Operately.Okrs.create_objective(params)
      end
    end

    field :add_members, :group do
      arg :group_id, non_null(:id)
      arg :person_ids, non_null(list_of(non_null(:id)))

      resolve fn args, _ ->
        group = Operately.Groups.get_group!(args.group_id)
        {:ok, _} = Operately.Groups.add_members(group, args.person_ids)

        {:ok, group}
      end
    end

    field :set_group_mission, :group do
      arg :group_id, non_null(:id)
      arg :mission, non_null(:string)

      resolve fn args, _ ->
        group = Operately.Groups.get_group!(args.group_id)
        {:ok, _} = Operately.Groups.set_mission(group, args.mission)

        {:ok, group}
      end
    end

    field :add_group_contact, :group do
      arg :group_id, non_null(:id)
      arg :contact, non_null(:contact_input)

      resolve fn args, _ ->
        group = Operately.Groups.get_group!(args.group_id)

        {:ok, _} = Operately.Groups.add_contact(
          group,
          args.contact.name,
          args.contact.value,
          args.contact.type
        )

        {:ok, group}
      end
    end

    field :create_update, :update do
      arg :input, non_null(:create_update_input)

      resolve fn args, %{context: context} ->
        Operately.Updates.create_update(%{
          author_id: context.current_account.person.id,
          updatable_type: args.input.updatable_type,
          updatable_id: args.input.updatable_id,
          content: args.input.content
        })
      end
    end

    field :create_comment, :comment do
      arg :input, non_null(:create_comment_input)

      resolve fn args, %{context: context} ->
        Operately.Updates.create_comment(%{
          author_id: context.current_account.person.id,
          update_id: args.input.update_id,
          content: args.input.content
        })
      end
    end
  end

  subscription do
    field :group_added, :group do
      config fn _, _ ->
        {:ok, %{topic: "*"}}
      end
    end

    field :project_added, :project do
      config fn _, _ ->
        {:ok, %{topic: "*"}}
      end
    end

    field :tenet_added, :tenet do
      config fn _, _ ->
        {:ok, %{topic: "*"}}
      end
    end

    field :kpi_added, :kpi do
      config fn _, _ ->
        {:ok, %{topic: "*"}}
      end
    end

    field :objective_added, :objective do
      config fn _, _ ->
        {:ok, %{topic: "*"}}
      end
    end

    field :update_added, :update do
      arg :updatable_id, non_null(:id)
      arg :updatable_type, non_null(:string)

      config fn _, _ ->
        {:ok, %{topic: "*"}}
      end
    end

    field :comment_added, :comment do
      arg :updatable_id, non_null(:id)
      arg :updatable_type, non_null(:string)

      config fn _, _ ->
        {:ok, %{topic: "*"}}
      end
    end
  end
end