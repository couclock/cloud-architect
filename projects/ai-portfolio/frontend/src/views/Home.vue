<script setup lang="ts">
  import { onMounted } from 'vue'
  import { useUsers } from '@/composables/useUsers'

  const { users, loading, error, fetchUsers } = useUsers()

  onMounted(() => {
    fetchUsers()
  })
</script>

<template>
  <v-container>
    <v-card>
      <v-card-title>Utilisateurs</v-card-title>

      <v-alert
        v-if="error"
        class="mb-4"
        type="error"
      >
        {{ error }}
      </v-alert>

      <v-data-table
        item-key="id"
        :items="users"
        :loading="loading"
      />
    </v-card>
  </v-container>
</template>
