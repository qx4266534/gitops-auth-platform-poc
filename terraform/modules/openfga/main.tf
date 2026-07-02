# OpenFGA Store en Authorization Model
# Creeert een OpenFGA store met het authorization model voor een tenant

resource "openfga_store" "tenant_store" {
  name = var.tenant_name
}

resource "openfga_authorization_model" "model" {
  store_id = openfga_store.tenant_store.id

  model_json = jsonencode({
    schema_version = "1.1"
    type_definitions = [
      {
        type = "user"
      },
      {
        type = "tenant"
        relations = {
          owner = { directly_related_user_types = [{ type = "user" }] }
          developer = { directly_related_user_types = [{ type = "user" }] }
          po = { directly_related_user_types = [{ type = "user" }] }
          member = {
            union = {
              child = [
                { computedUserset = { object = "", relation = "owner" } },
                { computedUserset = { object = "", relation = "developer" } },
                { computedUserset = { object = "", relation = "po" } }
              ]
            }
          }
          can_manage_users = {
            computedUserset = { object = "", relation = "owner" }
          }
          can_deploy = {
            union = {
              child = [
                { computedUserset = { object = "", relation = "owner" } },
                { computedUserset = { object = "", relation = "developer" } }
              ]
            }
          }
        }
        metadata = {
          relations = {
            owner = { directly_related_user_types = [{ type = "user" }] }
            developer = { directly_related_user_types = [{ type = "user" }] }
            po = { directly_related_user_types = [{ type = "user" }] }
          }
        }
      }
    ]
  })
}

# Relationship tuples voor platform rollen
resource "openfga_relationship_tuple" "owner" {
  for_each = toset(var.owners)

  store_id = openfga_store.tenant_store.id
  user     = "user:${each.value}"
  relation = "owner"
  object   = "tenant:${var.tenant_name}"
}

resource "openfga_relationship_tuple" "developer" {
  for_each = toset(var.developers)

  store_id = openfga_store.tenant_store.id
  user     = "user:${each.value}"
  relation = "developer"
  object   = "tenant:${var.tenant_name}"
}

resource "openfga_relationship_tuple" "po" {
  for_each = toset(var.pos)

  store_id = openfga_store.tenant_store.id
  user     = "user:${each.value}"
  relation = "po"
  object   = "tenant:${var.tenant_name}"
}
