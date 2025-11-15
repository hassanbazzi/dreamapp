// API Client - All data fetching goes through here
// Components should NEVER import db directly, only use this API client

export const api = {
  // Example: Notes API
  notes: {
    list: async () => {
      const res = await fetch("/api/notes")
      if (!res.ok) throw new Error("Failed to fetch notes")
      return res.json()
    },
    create: async (data: { title: string; body?: string }) => {
      const res = await fetch("/api/notes", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
      })
      if (!res.ok) throw new Error("Failed to create note")
      return res.json()
    },
    update: async (id: string, data: { title?: string; body?: string }) => {
      const res = await fetch(`/api/notes/${id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
      })
      if (!res.ok) throw new Error("Failed to update note")
      return res.json()
    },
    delete: async (id: string) => {
      const res = await fetch(`/api/notes/${id}`, { method: "DELETE" })
      if (!res.ok) throw new Error("Failed to delete note")
    },
  },

  // Add more API methods here as needed
  // The AI will extend this file when building new features
}

