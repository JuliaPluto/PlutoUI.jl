### A Pluto.jl notebook ###
# v0.20.20

using Markdown
using InteractiveUtils

# ╔═╡ 304b8b51-986a-4125-b3b1-acb38d3f90b5
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	import Pkg
	Pkg.activate(Base.current_project(@__DIR__))
	Pkg.instantiate()
	Text("Project env active")
end
  ╠═╡ =#

# ╔═╡ 97bd5888-08fe-4498-b48e-dd4db0a2f590
begin
	using HypertextLiteral
	using Markdown
end

# ╔═╡ b7afb360-f1ec-4eb4-8bd8-e82d71ad5171
# Styles
const reading_time_css = @htl """
<style>
.pluto-reading-time {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    font-weight: 500;
    font-size: 0.875rem;
    line-height: 1.25;
    transition: all 0.2s ease-in-out;
    user-select: none;
}

.pluto-reading-time .reading-time-content {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.pluto-reading-time .reading-icon {
    font-size: 1rem;
    opacity: 0.8;
}

.pluto-reading-time .reading-text {
    font-variant-numeric: tabular-nums;
    letter-spacing: 0.025em;
}

/* Top position styling */
.pluto-reading-time.top {
    position: sticky;
    top: 0;
    z-index: 100;
    background: rgba(255, 255, 255, 0.85);
    backdrop-filter: blur(12px) saturate(1.2);
    border-bottom: 1px solid rgba(0, 0, 0, 0.08);
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    padding: 0.75rem 1.5rem;
    text-align: center;
    margin-bottom: 1.5rem;
    color: rgba(0, 0, 0, 0.7);
}

.pluto-reading-time.top:hover {
    background: rgba(255, 255, 255, 0.95);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

/* Floating position styling */
.pluto-reading-time.floating {
    position: fixed;
    top: 4rem;
    right: 1rem;
    z-index: 1000;
    background: rgba(0, 0, 0, 0.75);
    backdrop-filter: blur(8px);
    color: rgba(255, 255, 255, 0.95);
    padding: 0.5rem 0.875rem;
    border-radius: 1.5rem;
    font-size: 0.8125rem;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15), 
                0 2px 4px rgba(0, 0, 0, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.1);
}

.pluto-reading-time.floating:hover {
    background: rgba(0, 0, 0, 0.85);
    transform: translateY(-1px);
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2), 
                0 3px 6px rgba(0, 0, 0, 0.15);
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
    .pluto-reading-time.top {
        background: rgba(24, 24, 27, 0.85);
        border-bottom-color: rgba(255, 255, 255, 0.1);
        color: rgba(255, 255, 255, 0.8);
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
    }
    
    .pluto-reading-time.top:hover {
        background: rgba(24, 24, 27, 0.95);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.4);
    }
    
    .pluto-reading-time.floating {
        background: rgba(255, 255, 255, 0.85);
        color: rgba(0, 0, 0, 0.85);
        border-color: rgba(0, 0, 0, 0.1);
    }
    
    .pluto-reading-time.floating:hover {
        background: rgba(255, 255, 255, 0.95);
    }
}

/* Mobile responsiveness */
@media (max-width: 768px) {
    .pluto-reading-time.top {
        padding: 0.625rem 1rem;
        font-size: 0.8125rem;
        margin-bottom: 1rem;
    }
    
    .pluto-reading-time.floating {
        top: 0.75rem;
        right: 0.75rem;
        font-size: 0.75rem;
        padding: 0.375rem 0.625rem;
        border-radius: 1.25rem;
    }
    
    .pluto-reading-time .reading-time-content {
        gap: 0.375rem;
    }
    
    .pluto-reading-time .reading-icon {
        font-size: 0.875rem;
    }
}

/* Extra small screens */
@media (max-width: 480px) {
    .pluto-reading-time.top {
        padding: 0.5rem 0.75rem;
        font-size: 0.75rem;
    }
    
    .pluto-reading-time.floating {
        top: 0.5rem;
        right: 0.5rem;
        font-size: 0.6875rem;
        padding: 0.25rem 0.5rem;
        border-radius: 1rem;
    }
}

/* Print styles */
@media print {
    .pluto-reading-time {
        display: none;
    }
}

/* High contrast mode support */
@media (prefers-contrast: high) {
    .pluto-reading-time.top {
        background: white;
        border-bottom: 2px solid black;
        color: black;
        backdrop-filter: none;
    }
    
    .pluto-reading-time.floating {
        background: black;
        color: white;
        border: 2px solid white;
        backdrop-filter: none;
    }
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce) {
    .pluto-reading-time,
    .pluto-reading-time:hover {
        transition: none;
        transform: none;
    }
}
</style>
"""

# ╔═╡ a2a3b8c6-2b45-4ab1-a631-1cb2cb9718b5
const reading_time_js = (estimator) -> @htl("""
											
<script>
// Text processing utilities
window.PlutoReadingTimeUtils = {
    countWordsInText: function(text) {
        if (!text || typeof text !== 'string') return 0;
        
        try {
            const normalizedText = text
                .replace(/\\s+/g, ' ')
                .trim()
                .toLowerCase();
            
            if (!normalizedText) return 0;
            
            const config = window.PlutoReadingTimeConfig;
            const words = normalizedText
                .split(/[\\s\\p{P}]+/u)
                .filter(word => {
                    return word.length >= config.MIN_WORD_LENGTH && 
                           word.length <= config.MAX_WORD_LENGTH &&
                           /[a-z]/i.test(word) &&
                           !/^\\d+\$/.test(word);
                });
            
            return words.length;
            
        } catch (error) {
            console.warn('Advanced word counting failed, using simple fallback:', error);
            return text.trim().split(/\\s+/).filter(word => word.length > 1).length;
        }
    },
    
    processMarkdownText: function(markdownText) {
        if (!markdownText || typeof markdownText !== 'string') return 0;
        
        try {
            let processedText = markdownText;
            
            // Remove code blocks
            processedText = processedText.replace(/\`\`\`[\\w]*[\\s\\S]*?\`\`\`/g, ' ');
            processedText = processedText.replace(/\`[^\`\\n]+\`/g, ' ');
            processedText = processedText.replace(/~~~[\\s\\S]*?~~~/g, ' ');
            
            // Process headers
            processedText = processedText.replace(/^#{1,6}\\s+(.+)\$/gm, '\$1 ');
            processedText = processedText.replace(/^(.+)\\n[=-]+\$/gm, '\$1 ');
            
            // Process links
            processedText = processedText.replace(/\\[([^\\]]+)\\]\\([^)]+\\)/g, '\$1 ');
            processedText = processedText.replace(/\\[([^\\]]+)\\]\\[[^\\]]+\\]/g, '\$1 ');
            
            // Process images
            processedText = processedText.replace(/!\\[([^\\]]*)\\]\\([^)]+\\)/g, '\$1 ');
            
            // Process emphasis
            processedText = processedText.replace(/\\*\\*\\*([^*]+)\\*\\*\\*/g, '\$1 ');
            processedText = processedText.replace(/\\*\\*([^*]+)\\*\\*/g, '\$1 ');
            processedText = processedText.replace(/\\*([^*]+)\\*/g, '\$1 ');
            processedText = processedText.replace(/___([^_]+)___/g, '\$1 ');
            processedText = processedText.replace(/__([^_]+)__/g, '\$1 ');
            processedText = processedText.replace(/_([^_]+)_/g, '\$1 ');
            
            // Process strikethrough
            processedText = processedText.replace(/~~([^~]+)~~/g, '\$1 ');
            
            // Remove remaining markdown syntax
            processedText = processedText.replace(/^\\s*[-*_]{3,}\\s*\$/gm, ' ');
            processedText = processedText.replace(/^\\s*>+\\s*/gm, ' ');
            processedText = processedText.replace(/^\\s*[*+-]\\s+/gm, ' ');
            processedText = processedText.replace(/^\\s*\\d+\\.\\s+/gm, ' ');
            processedText = processedText.replace(/\\|/g, ' ');
            processedText = processedText.replace(/[\`~#\\[\\](){}]/g, ' ');
            
            return this.countWordsInText(processedText);
            
        } catch (error) {
            console.warn('Markdown processing failed, using raw text:', error);
            return this.countWordsInText(markdownText);
        }
    },
    
    extractTextFromHTML: function(htmlString) {
        if (!htmlString || typeof htmlString !== 'string') return 0;
        
        try {
            const parser = new DOMParser();
            const doc = parser.parseFromString(htmlString, 'text/html');
            
            const unwantedElements = doc.querySelectorAll('script, style, noscript');
            unwantedElements.forEach(el => el.remove());
            
            const cleanText = doc.body.textContent || doc.documentElement.textContent || '';
            return this.countWordsInText(cleanText);
            
        } catch (error) {
            console.warn('HTML parsing failed, using regex fallback:', error);
            const textOnly = htmlString
                .replace(/<script[^>]*>[\\s\\S]*?<\\/script>/gi, '')
                .replace(/<style[^>]*>[\\s\\S]*?<\\/style>/gi, '')
                .replace(/<[^>]+>/g, ' ')
                .replace(/&\\w+;/g, ' ');
            
            return this.countWordsInText(textOnly);
        }
    }
};
// Content extraction functions
window.PlutoReadingTimeExtractor = {
    extractNotebookContent: function() {
        let totalWordCount = 0;
        
        try {
            const notebook = document.querySelector('pluto-notebook');
            if (!notebook) {
                console.warn('Pluto notebook not found');
                return 0;
            }
            
            const cells = notebook.querySelectorAll('pluto-cell');
            //console.log(\`Processing \${cells.length} Pluto cells\`);
            
            for (const cell of cells) {
                try {
                    const cellWordCount = this.extractCellContent(cell);
                    totalWordCount += cellWordCount;
                    
                    if (cellWordCount > 0) {
                        //console.log(\`Cell contributed \${cellWordCount} words\`);
                    }
                } catch (error) {
                    console.warn('Error processing individual cell:', error);
                }
            }
            
        } catch (error) {
            console.error('Critical error in notebook content extraction:', error);
            return 0;
        }
        
        //console.log(\`Total extracted words: \${totalWordCount}\`);
        return totalWordCount;
    },
    
    extractCellContent: function(cell) {
        let cellContent = '';

		// The original plan was to parse input codes to search for text and scripts 
		// This currently doesnt work since Ppluto lazy loads some parts of the input code so the count is not accurate 

        // Strategy 1: CodeMirror editor content
        // const cmEditor = cell.querySelector('.cm-editor .cm-scroller .cm-content');
        //if (cmEditor) {
        //    cellContent += cmEditor.textContent || '';
        //}
        
        // Strategy 2: Script tags containing cell source code
        const codeScripts = cell.querySelectorAll('script[type="text/plain"]');
        codeScripts.forEach(script => {
            const scriptContent = script.textContent || '';
            if (scriptContent && !cellContent.includes(scriptContent)) {
                cellContent += ' ' + scriptContent;
            }
        });
        
        // Strategy 3: Data attributes
        if (cell.dataset && cell.dataset.code) {
            cellContent += ' ' + cell.dataset.code;
        }
        
        // Strategy 4: Static markdown/HTML outputs
        const staticOutputs = cell.querySelectorAll('.pluto-output, .markdown');
        staticOutputs.forEach(output => {
            const outputText = output.textContent || '';

            if (outputText && !cellContent.includes(outputText)) {
                cellContent += ' ' + outputText;
            }
        });
        return cellContent ? this.processJuliaNotebookContent(cellContent) : 0;
    },
    
    processJuliaNotebookContent: function(content) {
        if (!content || typeof content !== 'string') return 0;
        
        let totalWordCount = 0;
        const utils = window.PlutoReadingTimeUtils;
        totalWordCount = utils.countWordsInText(content);

		// Disabled for now, but maybe this can work later if we can get the notebook cells dirrectly from pluto but idk
        //try {
            // Extract Markdown content
          //  totalWordCount += this.extractMarkdownContent(content);
            
            // Extract HTML content
            //totalWordCount += this.extractHTMLContent(content);
        
            // Extract Julia docstrings
            //totalWordCount += this.extractDocstrings(content);
            
            // Extract meaningful comments
            //totalWordCount += this.extractComments(content);
            
            // Extract string literals
            //totalWordCount += this.extractReadableStringLiterals(content);
            
        //} catch (error) {
            //console.error('Error processing notebook content, falling back to simple counting:', error);
            //totalWordCount = utils.countWordsInText(content);
        //}
      	
        return totalWordCount;
    },
    
    extractMarkdownContent: function(content) {
        const markdownPatterns = [
            /md"([^"]*?)"/g,
            /md\"\"\\"([\\s\\S]*?)\"\"\"/g,
            /Markdown\\.md"([^"]*?)"/g,
            /Markdown\\.md\"\"\\"([\\s\\S]*?)\"\"\"/g
        ];
        
        let wordCount = 0;
        const utils = window.PlutoReadingTimeUtils;
        
        markdownPatterns.forEach(pattern => {
            const matches = [...content.matchAll(pattern)];
            matches.forEach(match => {
                if (match[1] && match[1].trim()) {
                    wordCount += utils.processMarkdownText(match[1]);
                }
            });
        });
        
        return wordCount;
    },
    
    extractHTMLContent: function(content) {
        const htmlPatterns = [
            /html"([\\s\\S]*?)"/g,
            /html\"\"\\"([\\s\\S]*?)\"\"\"/g,
            /@htl\\s*[\`"]?\\s*\"\"\\"([\\s\\S]*?)\\\"\\\"\\\"\\s*[\`"]?/g,
            /@htl\\s+"([^"]*?)"/g
        ];
        
        let wordCount = 0;
        const utils = window.PlutoReadingTimeUtils;
        
        htmlPatterns.forEach(pattern => {
            const matches = [...content.matchAll(pattern)];
            matches.forEach(match => {
                if (match[1] && match[1].trim()) {
                    wordCount += utils.extractTextFromHTML(match[1]);
                }
            });
        });
        
        return wordCount;
    },
    
    extractDocstrings: function(content) {
        const docstringPattern = /\"\"\\"([\\s\\S]*?)\"\"\"/g;
        const matches = [...content.matchAll(docstringPattern)];
        
        let wordCount = 0;
        const utils = window.PlutoReadingTimeUtils;
        
        matches.forEach(match => {
            if (match[1] && match[1].trim()) {
                wordCount += utils.processMarkdownText(match[1]);
            }
        });
        
        return wordCount;
    },
    
    extractComments: function(content) {
        const commentPattern = /^\\s*#\\s+(.+)\$/gm;
        const matches = [...content.matchAll(commentPattern)];
        
        let wordCount = 0;
        const utils = window.PlutoReadingTimeUtils;
        
        matches.forEach(match => {
            const comment = match[1].trim();
            
            if (comment.length > 10 && 
                !comment.includes('╔═╡') && 
                !comment.match(/^[a-f0-9-]{8,}\$/)) {
                wordCount += utils.countWordsInText(comment);
            }
        });
        
        return wordCount;
    },
    
    extractReadableStringLiterals: function(content) {
        const stringPattern = /"([^"\\\\]*(\\\\.[^"\\\\]*)*)"/g;
        const matches = [...content.matchAll(stringPattern)];
        
        let wordCount = 0;
        const utils = window.PlutoReadingTimeUtils;
        
        matches.forEach(match => {
            const str = match[1];
            if (str && str.length > 20 && !str.match(/^[\\s\\W]*\$/)) {
                wordCount += utils.countWordsInText(str);
            }
        });
        
        return wordCount;
    }
};
// Update and caching system
window.PlutoReadingTimeUpdater = {
    getCachedWordCount: function() {
        const globalState = window.PlutoReadingTime;
        const config = window.PlutoReadingTimeConfig;
        const currentTime = Date.now();
        
        if (globalState.notebookCache !== null && 
            (currentTime - globalState.cacheValidTime) < config.CACHE_DURATION) {
            return globalState.notebookCache;
        }
        
        //console.log('Cache miss, recalculating word count...');
        const wordCount = window.PlutoReadingTimeExtractor.extractNotebookContent();
        
        globalState.notebookCache = wordCount;
        globalState.cacheValidTime = currentTime;
        
        return wordCount;
    },
    
    invalidateCache: function() {
        const globalState = window.PlutoReadingTime;
        globalState.notebookCache = null;
        globalState.cacheValidTime = 0;
        //console.log('Cache invalidated');
    },
    
    scheduleGlobalUpdate: function() {
        const globalState = window.PlutoReadingTime;
        const config = window.PlutoReadingTimeConfig;
        
        if (globalState.updateTimeout) {
            clearTimeout(globalState.updateTimeout);
        }
        
        if (globalState.isUpdating) {
            //console.log('Update already in progress, skipping...');
            return;
        }
        
        globalState.updateTimeout = setTimeout(() => {
            this.performGlobalUpdate();
        }, config.UPDATE_DELAY);
    },
    
    performGlobalUpdate: function() {
        const globalState = window.PlutoReadingTime;
        
        if (globalState.isUpdating) return;
        
        globalState.isUpdating = true;
        //console.log('Performing global reading time update...');

        try {
            const wordCount = this.getCachedWordCount();
            
            globalState.instances.forEach(instance => {
                this.updateInstance(instance, wordCount);
            });
            
            
        } catch (error) {
            console.error('Global update failed:', error);
            
            globalState.instances.forEach(instance => {
                const textElement = instance.node.querySelector('.reading-text');
                if (textElement) {
                    textElement.textContent = 'Calculation error';
                }
            });
        } finally {
            globalState.isUpdating = false;
        }
    },
    
    updateInstance: function(instance, wordCount) {
        try {
            const readingMinutes = Math.max(1, Math.ceil(wordCount / instance.config.WPM));
            
            let displayText;
            switch(instance.config.STYLE) {
                case 'minimal':
                    displayText = \`\${readingMinutes} min read\`;
                    break;
                case 'detailed':
                    displayText = \`Reading time: \${readingMinutes} minute\${readingMinutes !== 1 ? 's' : ''} (\${wordCount} words at \${instance.config.WPM} wpm)\`;
                    break;
                default:
                    displayText = \`\${readingMinutes} min read\`;
            }
            
            const textElement = instance.node.querySelector('.reading-text');
            if (textElement && textElement.textContent !== displayText) {
                textElement.textContent = displayText;
                //console.log(\`Updated instance: \${displayText}\`);
            }
            
        } catch (error) {
            console.error('Failed to update individual instance:', error);
            const textElement = instance.node.querySelector('.reading-text');
            if (textElement) {
                textElement.textContent = 'Error';
            }
        }
    }
};
// DOM observer system
window.PlutoReadingTimeObserver = {
    setupDOMObservers: function() {
        const globalState = window.PlutoReadingTime;
        
        if (globalState.observers.size > 0) {
            //console.log('DOM observers already set up');
            return;
        }
        
        try {
            const notebook = document.querySelector("pluto-notebook");
            if (!notebook) {
                console.warn('Pluto notebook not found for observer setup');
                return;
            }
            
            this.setupNotebookObserver(notebook);
            this.setupCellObservers(notebook);
            
            //console.log(\`Set up \${globalState.observers.size} DOM observers\`);
            
        } catch (error) {
            console.error('Failed to set up DOM observers:', error);
        }
    },
    
    setupNotebookObserver: function(notebook) {
        const globalState = window.PlutoReadingTime;
        const updater = window.PlutoReadingTimeUpdater;
        
        const notebookObserver = new MutationObserver((mutations) => {
            let requiresUpdate = false;
            
            mutations.forEach(mutation => {
                if (mutation.type === 'childList') {
                    const hasNewCells = Array.from(mutation.addedNodes).some(node => 
                        node.nodeType === Node.ELEMENT_NODE && node.matches('pluto-cell')
                    );
                    const hasRemovedCells = Array.from(mutation.removedNodes).some(node => 
                        node.nodeType === Node.ELEMENT_NODE && node.matches('pluto-cell')
                    );
                    
                    if (hasNewCells || hasRemovedCells) {
                        //console.log('Notebook structure changed: cells added/removed');
                        requiresUpdate = true;
                    }
                }
                
                if (mutation.type === 'attributes' && 
                    ['class', 'data-code'].includes(mutation.attributeName)) {
                    //console.log(\`Notebook attribute changed: \${mutation.attributeName}\`);
                    requiresUpdate = true;
                }
            });
            
            if (requiresUpdate) {
                updater.invalidateCache();
                updater.scheduleGlobalUpdate();
            }
        });
        
        notebookObserver.observe(notebook, { 
            childList: true, 
            subtree: true,
            attributes: true,
            attributeFilter: ['class', 'data-code']
        });
        
        globalState.observers.add(notebookObserver);
        //console.log('Notebook structure observer activated');
    },
    
    setupCellObservers: function(notebook) {
        const globalState = window.PlutoReadingTime;
        const updater = window.PlutoReadingTimeUpdater;
        const cells = notebook.querySelectorAll("pluto-cell");
        
        cells.forEach((cell, index) => {
            try {
                const cellObserver = new MutationObserver(() => {
                    //console.log(\`Cell \${index} content changed\`);
                    updater.invalidateCache();
                    updater.scheduleGlobalUpdate();
                });
                
                const codeEditor = cell.querySelector('.cm-editor');
                if (codeEditor) {
                    cellObserver.observe(codeEditor, {
                        childList: true,
                        subtree: true,
                        characterData: true
                    });
                    
                    globalState.observers.add(cellObserver);
                }
                
            } catch (error) {
                console.warn(\`Failed to set up observer for cell \${index}:\`, error);
            }
        });
        
        //console.log(\`Set up observers for \${cells.length} cells\`);
    }
};
											
	// Initialize global singleton state
	if (!window.PlutoReadingTime) {
	    window.PlutoReadingTime = {
	        instances: new Set(),
	        observers: new Set(),
	        contentCache: new WeakMap(),
	        updateTimeout: null,
	        isUpdating: false,
	        lastUpdateTime: 0,
	        notebookCache: null,
	        cacheValidTime: 0
	    };
	}
	
	// Configuration - replace with actual values
	window.PlutoReadingTimeConfig = {
	    WPM: $(estimator.wpm),
	    POSITION: $(string(estimator.position)),
	    STYLE: $(string(estimator.style)),
	    UPDATE_DELAY: 10,
	    CACHE_DURATION: 1000,
	    MIN_WORD_LENGTH: 2,
	    MAX_WORD_LENGTH: 50
	};
								
	function html(htmlString) {
	  const parser = new DOMParser();
	  const doc = parser.parseFromString(htmlString, 'text/html');
	  return doc.body.firstElementChild;
	}

	const readingTimeNode = html(`<div class="pluto-reading-time">
	<div class="reading-time-content">
		<span class="reading-icon" aria-hidden="true">
			📖
		</span>
		<span class="reading-text" role="status" aria-live="polite">
			Calculating...
		</span>
		</div>
	</div>`)

	
	readingTimeNode.classList.add(window.PlutoReadingTimeConfig.POSITION);
	readingTimeNode.classList.add(window.PlutoReadingTimeConfig.STYLE);
	
	(function() {
    	const globalState = window.PlutoReadingTime;
	    const config = window.PlutoReadingTimeConfig;
	    const updater = window.PlutoReadingTimeUpdater;
	    const observer = window.PlutoReadingTimeObserver;
	    // Create instance identifier
	    const instanceId = Symbol('readingTimeInstance');
    
	    // Register this instance
	    const instance = {
	        id: instanceId,
	        node: readingTimeNode,
	        config: config,
	        created: Date.now()
	    };
    
	    globalState.instances.add(instance);
	    // Initialize the system
	    function initialize() {
	        // console.log('Initializing Pluto Reading Time Estimator...');
	        
	        // Perform initial calculation
	        updater.scheduleGlobalUpdate();
	        
	        // Set up DOM monitoring
	        observer.setupDOMObservers();
	        
	        // console.log('Reading time estimator initialized successfully');
	    }
	    
	    // Cleanup function for when cell is re-evaluated
	    function cleanup() {
	        // Remove this instance from global state
	        const remainingInstances = [...globalState.instances].filter(inst => inst.id !== instanceId);
	        globalState.instances = new Set(remainingInstances);
	        
	        // If no instances remain, clean up global resources
	        if (globalState.instances.size === 0) {
	            if (globalState.updateTimeout) {
	                clearTimeout(globalState.updateTimeout);
	                globalState.updateTimeout = null;
	            }
	            
	            globalState.observers.forEach(obs => {
	                try {
	                    obs.disconnect();
	                } catch (error) {
	                    console.warn('Error disconnecting observer:', error);
	                }
	            });
	            
	            globalState.observers.clear();
	            globalState.contentCache = new WeakMap();
	            globalState.notebookCache = null;
	            globalState.isUpdating = false;
	            
	            // console.log('Global cleanup completed');
	        }
	    }
	    
	    // Set up cleanup for when this cell is re-evaluated
	    if (typeof invalidation !== 'undefined') {
	        invalidation.then(cleanup);
	    } else {
	        // Fallback cleanup registration
	        window.addEventListener('beforeunload', cleanup);
	    }
	    
	    // Initialize the component
		initialize();
	})();

	return readingTimeNode
</script>
""")

# ╔═╡ 47803bec-eca2-4c76-b1d4-c8951ee4ccda
begin
	local result = begin
		
		struct ReadingTimeEstimator
		    wpm::Int
		    position::Symbol
		    style::Symbol
			
			function ReadingTimeEstimator(; wpm::Int=200, position::Symbol=:top, style::Symbol=:minimal) 
			
				allowed_positions = [:top, :floating]
				
				if position ∉ allowed_positions
					throw(ArgumentError("Please select a position from the list of allowed positions :$allowed_positions. Got: `$position`
										"))
					
				end
			
				allowed_styles = [:minimal, :detailed]
				if style ∉ allowed_styles
					throw(ArgumentError("Please select a style from the list of allowed positions :$allowed_styles. Got: `$style`"))
				end
				
				new(wpm, position, style)
			end
		end

		@doc """
		Add a reading time estimate to your Pluto notebook based on markdown content.
		
		# Arguments
		- `wpm::Int=200`: Words per minute reading speed (typical range: 150-300)
		- `position::Symbol=:top`: Where to display (`:top` or `:floating`)
		- `style::Symbol=:minimal`: Display style (`:minimal` or `:detailed`)
		
		# Examples
		```julia
		reading_time()  # Simple "📖 5 min read"
		
		reading_time(wpm=250, style=:detailed)  # "📖 Reading time: 4 minutes (850 words at 250 wpm)"
		
		reading_time(position=:floating)  # Floating in corner
		```
		"""
		ReadingTimeEstimator
	end
	
	function Base.show(io::IO, m::MIME"text/html", estimator::ReadingTimeEstimator)
		Base.show(io, m, @htl("$(reading_time_js(estimator))$(reading_time_css)"))
	end
	
	result 
end

# ╔═╡ 7ecea127-265b-4eac-8fa0-e25e344d7e2b
ReadingTimeEstimator()

# ╔═╡ 89131e87-bd73-4cfa-a93c-2d45a46cd389
md"""
Nam vitae augue viverra, ullamcorper purus quis, egestas eros. Mauris congue ultrices interdum. Proin ut dictum odio, a blandit mi. Nullam porttitor odio eget mi porttitor dapibus. Ut in lacus nec eros tristique pellentesque. Curabitur quis quam sagittis quam tempus interdum et ut eros. Fusce non suscipit dui. Duis blandit turpis est, sit amet dictum quam luctus et. Praesent tempor, ex quis blandit consectetur, nisl nisl tincidunt lorem, ac molestie dolor nisi eget diam. Sed mollis, ligula id gravida gravida, sapien ante gravida quam, eu fermentum leo velit et magna. Mauris rutrum molestie sem sit amet finibus. 
"""

# ╔═╡ 1873d61f-a021-4919-9542-d91e019f9b59
export ReadingTimeEstimator

# ╔═╡ Cell order:
# ╠═304b8b51-986a-4125-b3b1-acb38d3f90b5
# ╠═97bd5888-08fe-4498-b48e-dd4db0a2f590
# ╠═47803bec-eca2-4c76-b1d4-c8951ee4ccda
# ╠═b7afb360-f1ec-4eb4-8bd8-e82d71ad5171
# ╠═a2a3b8c6-2b45-4ab1-a631-1cb2cb9718b5
# ╠═7ecea127-265b-4eac-8fa0-e25e344d7e2b
# ╠═89131e87-bd73-4cfa-a93c-2d45a46cd389
# ╠═1873d61f-a021-4919-9542-d91e019f9b59
