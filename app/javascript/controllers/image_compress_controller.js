import { Controller } from "@hotwired/stimulus"

const MAX_DIMENSION = 2000
const TARGET_SIZE_BYTES = 1_200_000
const JPEG_QUALITIES = [0.86, 0.78, 0.7, 0.62]

export default class extends Controller {
  static targets = ["input", "status"]

  connect() {
    this.isProcessing = false
    this.inputTarget.addEventListener("change", this.handleChange)
  }

  disconnect() {
    this.inputTarget.removeEventListener("change", this.handleChange)
  }

  handleChange = async () => {
    const files = Array.from(this.inputTarget.files || [])
    if (files.length === 0 || this.isProcessing) return

    this.isProcessing = true
    this.toggleSubmitButtons(true)
    this.setStatus("Optimisation des photos en cours...")

    try {
      const optimizedFiles = await Promise.all(files.map((file) => this.optimizeFile(file)))
      const dataTransfer = new DataTransfer()
      optimizedFiles.forEach((file) => dataTransfer.items.add(file))
      this.inputTarget.files = dataTransfer.files

      const before = files.reduce((sum, file) => sum + file.size, 0)
      const after = optimizedFiles.reduce((sum, file) => sum + file.size, 0)
      const saved = before - after

      if (saved > 0) {
        const mb = (saved / (1024 * 1024)).toFixed(2)
        this.setStatus(`Photos optimisées (gain: ${mb} Mo).`)
      } else {
        this.setStatus("Photos prêtes à l'envoi.")
      }
    } catch (_error) {
      this.setStatus("Impossible d'optimiser automatiquement ces photos.")
    } finally {
      this.isProcessing = false
      this.toggleSubmitButtons(false)
    }
  }

  async optimizeFile(file) {
    if (!file.type.startsWith("image/")) return file

    const bitmap = await this.loadBitmap(file)
    const width = bitmap.width || bitmap.naturalWidth
    const height = bitmap.height || bitmap.naturalHeight
    const largestSide = Math.max(width, height)
    const ratio = largestSide > MAX_DIMENSION ? MAX_DIMENSION / largestSide : 1
    const outputWidth = Math.round(width * ratio)
    const outputHeight = Math.round(height * ratio)

    // Garde le fichier original si la photo est déjà légère et pas trop grande.
    if (ratio === 1 && file.size <= TARGET_SIZE_BYTES) {
      if (typeof bitmap.close === "function") {
        bitmap.close()
      }
      return file
    }

    const canvas = document.createElement("canvas")
    canvas.width = outputWidth
    canvas.height = outputHeight
    const context = canvas.getContext("2d")
    if (!context) {
      if (typeof bitmap.close === "function") {
        bitmap.close()
      }
      return file
    }
    context.drawImage(bitmap, 0, 0, outputWidth, outputHeight)
    if (typeof bitmap.close === "function") {
      bitmap.close()
    }

    let bestBlob = null

    for (const quality of JPEG_QUALITIES) {
      const blob = await this.toJpegBlob(canvas, quality)
      if (!blob) continue

      if (!bestBlob || blob.size < bestBlob.size) {
        bestBlob = blob
      }

      if (blob.size <= TARGET_SIZE_BYTES) break
    }

    if (!bestBlob) return file

    if (bestBlob.size >= file.size) {
      return file
    }

    const newName = this.toJpegFileName(file.name)
    return new File([bestBlob], newName, { type: "image/jpeg", lastModified: file.lastModified })
  }

  toJpegBlob(canvas, quality) {
    return new Promise((resolve) => {
      canvas.toBlob((blob) => resolve(blob), "image/jpeg", quality)
    })
  }

  async loadBitmap(file) {
    if (typeof createImageBitmap === "function") {
      return createImageBitmap(file)
    }

    return this.loadImageElement(file)
  }

  loadImageElement(file) {
    return new Promise((resolve, reject) => {
      const image = new Image()
      const objectUrl = URL.createObjectURL(file)

      image.onload = () => {
        URL.revokeObjectURL(objectUrl)
        resolve(image)
      }

      image.onerror = () => {
        URL.revokeObjectURL(objectUrl)
        reject(new Error("Image decode failed"))
      }

      image.src = objectUrl
    })
  }

  toJpegFileName(name) {
    return name.replace(/\.[^/.]+$/, "") + ".jpg"
  }

  setStatus(message) {
    if (this.hasStatusTarget) {
      this.statusTarget.textContent = message
    }
  }

  toggleSubmitButtons(disabled) {
    this.element.querySelectorAll("button[type='submit'], input[type='submit']").forEach((button) => {
      button.disabled = disabled
    })
  }
}
