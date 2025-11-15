import { notes } from "@/db/schema"
import { db } from "@/lib/db"
import { eq } from "drizzle-orm"
import { NextRequest, NextResponse } from "next/server"

// PATCH /api/notes/[id] - Update a note
export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params
    const body = await request.json()
    const { title, body: noteBody } = body

    const [note] = await db
      .update(notes)
      .set({
        ...(title && { title }),
        ...(noteBody !== undefined && { body: noteBody }),
      })
      .where(eq(notes.id, id))
      .returning()

    if (!note) {
      return NextResponse.json({ error: "Note not found" }, { status: 404 })
    }

    return NextResponse.json(note)
  } catch (error) {
    console.error("Error updating note:", error)
    return NextResponse.json(
      { error: "Failed to update note" },
      { status: 500 }
    )
  }
}

// DELETE /api/notes/[id] - Delete a note
export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params

    await db.delete(notes).where(eq(notes.id, id))

    return NextResponse.json({ success: true })
  } catch (error) {
    console.error("Error deleting note:", error)
    return NextResponse.json(
      { error: "Failed to delete note" },
      { status: 500 }
    )
  }
}
